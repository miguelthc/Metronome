//
//  MetronomeEnvironment.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 17/07/2020.
//

import Foundation
import Combine
import SwiftUI

class MetronomeEnvironment: ObservableObject {
    @Published var measureType: MeasureType = MeasureType.Beats
    
    // Metronome
    @Published var metronome = Metronome()
    @Published var isPlaying = false
    
    // Measure
    @Published var selectedBeats: [Int] = []
    @Published var invalidBeats: [Int] = []
    @Published var multipleBeatsSelectionMode = false
    @Published var beatListZoomed = false
    
    @Published var rhythmEditorObject = RhythmEditorObject()
    var rhythmEditorCancellable: AnyCancellable? = nil
    
    
    @Published var beepOccured: Bool = false
    @Published var beatOccured: Bool = false
    var beatPlaying = 0
    
    private var tapTimeStamps: [Double] = []
    
    var beepOccuredCancellable: AnyCancellable?
    var beatCountCancellable: AnyCancellable?
    var beatOccuredCancellable: AnyCancellable?
    
    private let metronomeGenerator = MetronomeGenerator()
    
    init() {
        beepOccuredCancellable = metronomeGenerator.$beepOccured
            .receive(on: DispatchQueue.main)
            .assign(to: \.beepOccured, on: self)

        
        beatCountCancellable = metronomeGenerator.$beatCount
            .receive(on: DispatchQueue.main)
            .assign(to: \.beatPlaying, on: self)
        
        beatOccuredCancellable = metronomeGenerator.$beatOccured
            .receive(on: DispatchQueue.main)
            .assign(to: \.beatOccured, on: self)
        
        rhythmEditorCancellable = rhythmEditorObject.objectWillChange.sink { _ in
            self.objectWillChange.send()
        }
    }
    
    var bpm: Double {
        get{
            metronome.bpm
        }
        set(newBpm) {
            metronome.bpm = newBpm
            if isPlaying {
                metronomeGenerator.updateMetronome(metronome: metronome, wasPlaying: isPlaying)
            }
        }
    }
    
    var measure: Measure {
        get { metronome.measure }
        set{ metronome.measure = newValue }
    }
    
    var allBeatsSelected: Bool {
        return selectedBeats.count == measure.beatsPerMeasure && multipleBeatsSelectionMode
    }
    
    var showBeatEditor: Bool {
        return selectedBeats.count > 0
    }
    
    var beatListSize: Int {
        get {
            measure.beatsPerMeasure * 65 + (measure.beatsPerMeasure-1) * 8 + 8
        }
    }
    
    func changeMetronomePlayingState(){
        isPlaying.toggle()
        
        if(isPlaying){
            metronomeGenerator.updateMetronome(metronome: metronome, wasPlaying: false)
            metronomeGenerator.playMetronome()
        }else{
            metronomeGenerator.stopMetronome()
        }
    }
    
    func incrementBpm(){
        if(bpm+1 > Metronome.maxBpm) {
            bpm = Metronome.maxBpm
        }else{
            bpm += 1
        }
    }
    
    func decrementBpm(){
        if(bpm-1 < Metronome.minBpm) {
            bpm = Metronome.minBpm
        }else if(bpm > Metronome.maxBpm){
            bpm = Metronome.maxBpm
        }else{
            bpm -= 1
        }
    }
    
    func incrementBeatsPerMeasure(){
        if(measure.beatsPerMeasure < Measure.maxBeatsPerMeasure) {
            let newBeatRhythm = measure.defaultBeat()
            let newBeat = Beat(id: measure.beatsPerMeasure + 1, rhythm: newBeatRhythm)
            if(allBeatsSelected){
                selectedBeats.append(newBeat.id)
            }
            measure.beats.append(newBeat)
            
            if(measure.compound){
                measure.timeSignature.noteCount += 3
            }else{
                measure.timeSignature.noteCount += 1
            }
            
            updateMetronomeGenerator()
        }
    }
       
    func decrementBeatsPerMeasure(){
        if(measure.beatsPerMeasure > Measure.minBeatsPerMeasure) {
            if(selectedBeats.contains(measure.beatsPerMeasure)){
                selectedBeats.remove(at: selectedBeats.firstIndex(of: measure.beatsPerMeasure)!)
            }
            
            removeInvalidBeat(id: measure.beatsPerMeasure - 1)
            
            measure.beats.remove(at: measure.beatsPerMeasure - 1)
            
            if(measure.compound){
                measure.timeSignature.noteCount -= 3
            }else{
                measure.timeSignature.noteCount -= 1
            }
            
            updateMetronomeGenerator()
        }
    }
    
    func incrementMeasureNoteValue(){
        if(measure.timeSignature.noteValue.rawValue < NoteValueFraction.SIXTY_FOURTH.rawValue){
            measure.timeSignature.noteValue = NoteValueFraction.allCases[NoteValueFraction.allCases.firstIndex(of: measure.timeSignature.noteValue)! + 1]
        }
        
    }
       
    func decrementMeasureNoteValue(){
        if(measure.timeSignature.noteValue.rawValue > NoteValueFraction.allCases.first!.rawValue){
            measure.timeSignature.noteValue = NoteValueFraction.allCases[NoteValueFraction.allCases.firstIndex(of: measure.timeSignature.noteValue)! - 1]
        }
    }
    
    func selectAll(){
        multipleBeatsSelectionMode = true
        selectedBeats = []
        
        for i in 1...measure.beatsPerMeasure {
            selectedBeats.append(i)
        }
    }
    
    func unselectAll(){
        multipleBeatsSelectionMode = false
        selectedBeats = []
    }
    
    func deleteSelectedBeats(){
        let shouldReset: Bool = selectedBeats.contains(beatPlaying)
        
        for i in selectedBeats {
            for j in measure.beats.indices {
                if(measure.beats[j].id == i){
                    removeInvalidBeat(id: i)
                    measure.beats.remove(at: j)
                    
                    if(measure.compound){
                        measure.timeSignature.noteCount -= 3
                    }else{
                        measure.timeSignature.noteCount -= 1
                    }
                    
                    break
                }
            }
        }
        
        selectedBeats = []
        
        for i in measure.beats.indices {
            measure.beats[i].id = i+1
        }
        
        multipleBeatsSelectionMode = false
        
        if(shouldReset){
            resetMetronomeGenerator()
        }
        updateMetronomeGenerator()
    }
    
    func duplicateBeat(){
        let id = selectedBeats[0] + 1
        measure.beats.insert(Beat(id: id, rhythm: Rhythm(noteValues: measure.beats[id-2].rhythm.noteValues)), at: id-1)
        
        if(measure.compound){
            measure.timeSignature.noteCount += 3
        }else{
            measure.timeSignature.noteCount += 1
        }
        
        //change beats id
        for i in id..<measure.beats.count {
            measure.beats[i].id += 1
        }
        
        updateMetronomeGenerator()
    }
    
    func zoomBeats(){
        beatListZoomed.toggle()
    }
    
    func selectBeat(id: Int){
        if selectedBeats.count == 0 {
            selectedBeats = [id]
        } else {
            if multipleBeatsSelectionMode {
                if(selectedBeats.contains(id)){ // Remove Beat From Selected Beats
                    for index in selectedBeats.indices{
                        if(selectedBeats[index] == id){
                            selectedBeats.remove(at: index)
                            break;
                        }
                    }
                }else{
                    selectedBeats.append(id)
                }
                
                if selectedBeats.count == 0 {
                    multipleBeatsSelectionMode = false
                }
            } else {
                let previouslySelectedBeat = selectedBeats[0]
                
                selectedBeats = []
                
                if(!(id == previouslySelectedBeat)){
                    selectedBeats = [id]
                }
            }
        }
    }
    
    func selectMultipleBeat(id: Int){
        if (multipleBeatsSelectionMode){
            selectedBeats = []
            selectedBeats.append(id)
        }else if(!selectedBeats.contains(id)){
            selectedBeats.append(id)
        }
        multipleBeatsSelectionMode.toggle()
    }
    
    func selectRhythm(rhythm: Rhythm){
        for selectedBeat in selectedBeats {
            measure.beats[selectedBeat-1].rhythm = rhythm
            
            if(invalidBeats.contains(selectedBeat)){
                invalidBeats.remove(at: invalidBeats.firstIndex(of: selectedBeat)!)
            }
        }
        
        if(selectedBeats.contains(beatPlaying)){
            resetMetronomeGenerator()
        }
        
        updateMetronomeGenerator()
    }
    
    func replaceInvalidRhythm(id: Int){
        invalidBeats.append(id)
        measure.beats[id-1].rhythm = measure.defaultBeat()
        
        if(selectedBeats.contains(beatPlaying)){
            resetMetronomeGenerator()
        }
        
        updateMetronomeGenerator()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.removeInvalidBeat(id: id)
        }
    }
    
    func beepOccuredDisplayed(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.025) {
            self.metronomeGenerator.beepOccured = false
        }
    }
    
    func beatOccuredDisplayed(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.025) {
            self.metronomeGenerator.beatOccured = false
        }
    }
    
    func tap(){
        let currentTimeStamp = Date.timeIntervalSinceReferenceDate
        
        if (tapTimeStamps.count > 0) {
            let newInterval = currentTimeStamp - tapTimeStamps.last!
            
            if(newInterval > 2 ||
                tapTimeStamps.count > 2 &&
                (tapTimeStamps.last! - tapTimeStamps[tapTimeStamps.count-2] > newInterval * 1.2 ||
                    tapTimeStamps.last! - tapTimeStamps[tapTimeStamps.count-2] < newInterval / 1.2)
            ){
                tapTimeStamps = []
            }else if tapTimeStamps.count == 5 {
                tapTimeStamps.removeFirst()
            }
        }
        
        tapTimeStamps.append(currentTimeStamp)
        
        if tapTimeStamps.count > 1 {
            var timeIntervals: [Double] = []
            
            for index in 1..<tapTimeStamps.count {
                timeIntervals.append(tapTimeStamps[index] - tapTimeStamps[index - 1])
            }
            
            var timeIntervalSum: Double = 0
            
            for timeInterval in timeIntervals {
                timeIntervalSum += timeInterval
            }
            
            bpm = 60 / (timeIntervalSum / Double(timeIntervals.count))
        }
    }
    
    func toggleCompoundMeasure(){
        measure.compound.toggle()
        
        selectedBeats = []
        invalidBeats = []
        measure.beats = []
        
        for i in 1...measure.beatsPerMeasure{
            measure.beats.append(Beat(id: i, rhythm: measure.defaultBeat()))
        }
        
        updateMetronomeGenerator()
    }
    
    private func removeInvalidBeat(id: Int){
        if(self.invalidBeats.contains(id)){
            self.invalidBeats.remove(at: self.invalidBeats.firstIndex(of: id)!)
        }
    }
    
    private func updateMetronomeGenerator(){
        if isPlaying {
            metronomeGenerator.updateMetronome(metronome: metronome, wasPlaying: isPlaying)
        }
    }
    
    private func resetMetronomeGenerator(){
        if isPlaying {
            metronomeGenerator.stopMetronome()
            metronomeGenerator.playMetronome()
        }
    }
    
}

enum MeasureType {
    case Simple
    case Beats
    case Square
}
