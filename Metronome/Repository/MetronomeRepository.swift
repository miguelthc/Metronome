//
//  MetronomeRepository.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 18/07/2020.
//


let TABLES_INIT = "tablesInitiated"
let LAST_USED_METRONOME = "lastUsedMetronome"

import Foundation

class MetronomeRepository: ObservableObject {
    @Published var simplePickerRhythms: [Rhythm] = []
    @Published var compoundPickerRhythms: [Rhythm] = []
    
    private let dao = DAO()
    let userDefaults = UserDefaults()
    
    init(){
        if !userDefaults.bool(forKey: TABLES_INIT) {
            initTables()
            userDefaults.set(true, forKey: TABLES_INIT)
        }
        
        simplePickerRhythms = loadSimplePickerRhythms()
        compoundPickerRhythms = loadCompoundPickerRhythms()
    }
    
    var lastUsedMetronome: Metronome {
        get {
            guard let name = userDefaults.string(forKey: LAST_USED_METRONOME)
            else {
                return Metronome()
            }
            
            return loadMetronome(name: name)
        } set {
            userDefaults.setValue(newValue.name, forKey: LAST_USED_METRONOME)
        }
    }
    
    var metronomeCount: Int {  dao.metronomeCount }
   
    private func initTables(){
        for rhythm in MetronomeRepository.initialSimpleRhythms {
            addPickerRhythm(rhythm: rhythm, compound: false)
        }
        
        for rhythm in MetronomeRepository.initialCompoundRhythms {
            addPickerRhythm(rhythm: rhythm, compound: true)
        }
    }
    
    func addRhythm(rhythm: Rhythm, compound: Bool){
        var i: Int = 0
        var repeated: Bool = false
        
        for repRhythm in compound ? compoundPickerRhythms : simplePickerRhythms {
            i = 0
            repeated = true
            
            while (i < rhythm.noteValues.count && i < repRhythm.noteValues.count){
                let differentFraction = rhythm.noteValues[i].fractionOfBeat != repRhythm.noteValues[i].fractionOfBeat
                let oneIsRest = (rhythm.noteValues[i].isRest && !repRhythm.noteValues[i].isRest) ||
                    (!rhythm.noteValues[i].isRest && repRhythm.noteValues[i].isRest)
                let oneIsAccented = (rhythm.noteValues[i].accent && !repRhythm.noteValues[i].accent) ||
                    (!rhythm.noteValues[i].accent && repRhythm.noteValues[i].accent)
                
                if(differentFraction || oneIsRest || oneIsAccented){
                    repeated = false
                    break
                }
                
                i += 1
            }
            
            if(repeated){
                break
            }
        }
        
        if(!repeated){
            if(compound){
                compoundPickerRhythms.append(rhythm)
            }else{
                simplePickerRhythms.append(rhythm)
            }
            
            addPickerRhythm(rhythm: rhythm, compound: compound)
        }
    }
    
    func validRhythms(timeSignatureNoteValue: NoteValueFraction, compound: Bool) -> [Rhythm] {
        var valid: [Rhythm] = []
        
        for rhythm in compound ? compoundPickerRhythms : simplePickerRhythms {
            if rhythm.isValid(timeSignatureNoteValue: timeSignatureNoteValue){
                valid.append(rhythm)
            }
        }
        
        return valid
    }
    
    func addMetronome(metronome: Metronome){
        dao.insertMetronome(metronome: StoreMetronome(
                                name: metronome.name,
                                bpm: metronome.bpm,
                                timeSignatureNoteCount: metronome.measure.timeSignature.noteCount,
                                timeSignatureNoteValue: metronome.measure.timeSignature.noteValue.rawValue,
                                compound: metronome.measure.compound,
                                beats: beatsToDescription(beats: metronome.measure.beats)))
    }
    
    func loadMetronomes(sorting: Sorting, reverse: Bool = false) -> [Metronome]{
        var metronomeList: [Metronome] = []
        
        for storeMetronome in dao.selectMetronomes() {
            metronomeList.append(storeMetronomeToMetronome(storeMetronome: storeMetronome))
        }
        
        //TODO: SORT
        
        return metronomeList
    }
    
    func loadMetronome(name: String) -> Metronome{
        return storeMetronomeToMetronome(storeMetronome: dao.selectMetronome(name: name)!)
    }
    
    func defaultMetronomeName() -> String {
        var i = 0;
        var exists = true
        var name = ""
        
        while(exists){
            name = Metronome.defaultName
            if(i != 0){
                name += " \(i)"
            }
            
            if(!dao.metronomeExists(name: name)){
                exists = false
            }
            
            i += 1
        }
        
        return name
    }
}

extension MetronomeRepository {
    private func addPickerRhythm(rhythm: Rhythm, compound: Bool){
        let rhythmDescription = rhythmToDescription(rhythm: rhythm)
        
        if(compound){
            dao.insertCompoundRhythm(rhythmDescription: rhythmDescription)
        }else{
            dao.insertSimpleRhythm(rhythmDescription: rhythmDescription)
        }
    }
    
    private func loadSimplePickerRhythms() -> [Rhythm] {
        var pickerRhythms: [Rhythm] = []
        
        for description in dao.selectSimpleRhythms() {
            pickerRhythms.append(descriptionToRhythm(description: description))
        }
        
        return pickerRhythms
    }
    
    private func loadCompoundPickerRhythms() -> [Rhythm] {
        var pickerRhythms: [Rhythm] = []
        
        for description in dao.selectCompoundRhythms() {
            pickerRhythms.append(descriptionToRhythm(description: description))
        }
        
        return pickerRhythms
    }
    
    private func rhythmToDescription(rhythm: Rhythm) -> String {
        var rhythmDescription = ""
        
        for noteValue in rhythm.noteValues {
            rhythmDescription.append("\(noteValue.baseFraction) \(noteValue.isRest) \(noteValue.accent) \(noteValue.dots)\n")
        }
        
        return rhythmDescription
    }
    
    private func descriptionToRhythm(description: String) -> Rhythm {
        var description = description
        var noteValues: [NoteValue] = []
        
        while (description.count > 0) {
            let baseFraction = Int(description.prefix(upTo: description.firstIndex(of: " ")!))
            description.removeSubrange(description.startIndex...description.firstIndex(of: " ")!)
            let isRest: Bool = description.prefix(upTo: description.firstIndex(of: " ")!) == "true" ? true : false
            description.removeSubrange(description.startIndex...description.firstIndex(of: " ")!)
            let accent: Bool = description.prefix(upTo: description.firstIndex(of: " ")!) == "true" ? true : false
            description.removeSubrange(description.startIndex...description.firstIndex(of: " ")!)
            let dots = Int(description.prefix(upTo: description.firstIndex(of: "\n")!))
            description.removeSubrange(description.startIndex...description.firstIndex(of: "\n")!)
            
            noteValues.append(NoteValue(baseFraction: baseFraction!, isRest: isRest, accent: accent, dots: dots!))
        }
        
        return Rhythm(noteValues: noteValues)
    }
    
    private func beatDescriptionToList(description: String) -> [Beat] {
        var beats: [Beat] = []
        var description = description
        
        var i = 1
        while (description.count > 0) {
            let rhythmDescription = description.prefix(upTo: description.firstIndex(of: "b")!)
            description.removeSubrange(description.startIndex...description.firstIndex(of: "b")!)
            description.removeFirst()
            
            beats.append(Beat(id: i, rhythm: descriptionToRhythm(description: String(rhythmDescription))))
            i += 1
        }
        
        return beats
    }
    
    private func beatsToDescription(beats: [Beat]) -> String {
        var description = ""
        
        for beat in beats {
            description.append(rhythmToDescription(rhythm: beat.rhythm))
            description.append("b\n")
        }
        
        return description
    }
    
    private func storeMetronomeToMetronome(storeMetronome: StoreMetronome) -> Metronome {
        return Metronome(name: storeMetronome.name,
                                       bpm: storeMetronome.bpm,
                                       measure: Measure(
                                        timeSignature: TimeSignature(
                                            noteCount: storeMetronome.timeSignatureNoteCount,
                                            noteValue: NoteValueFraction(rawValue: storeMetronome.timeSignatureNoteValue)!),
                                        beats: beatDescriptionToList(description: storeMetronome.beats),
                                        compound: storeMetronome.compound
                                       ))
    }
    
    static let initialSimpleRhythms: [Rhythm] = [
            Rhythm(),
            Rhythm(noteValues: [NoteValue(baseFraction: 2), NoteValue(baseFraction: 2)]),
            Rhythm(noteValues: [NoteValue(baseFraction: 2, isRest: true), NoteValue(baseFraction: 2)]),
            Rhythm(noteValues: [NoteValue(baseFraction: 2), NoteValue(baseFraction: 4), NoteValue(baseFraction: 4)]),
            Rhythm(noteValues: [NoteValue(baseFraction: 4), NoteValue(baseFraction: 2), NoteValue(baseFraction: 4)]),
            Rhythm(noteValues: [NoteValue(baseFraction: 4), NoteValue(baseFraction: 4), NoteValue(baseFraction: 2)]),
            Rhythm(noteValues: [NoteValue(baseFraction: 4), NoteValue(baseFraction: 4), NoteValue(baseFraction: 2)]),
            Rhythm(noteValues: [NoteValue(baseFraction: 2, dots: 1), NoteValue(baseFraction: 4)]),
            Rhythm(noteValues: [NoteValue(baseFraction: 4), NoteValue(baseFraction: 2, dots: 1)]),
            Rhythm(noteValues: [NoteValue(baseFraction: 4), NoteValue(baseFraction: 4), NoteValue(baseFraction: 4), NoteValue(baseFraction: 4)])
    ]
    
    static let initialCompoundRhythms: [Rhythm] = [
        Rhythm(noteValues: [NoteValue(baseFraction: 1, dots: 1)]),
        Rhythm(noteValues: [NoteValue(baseFraction: 2), NoteValue(baseFraction: 2), NoteValue(baseFraction: 2)]),
        Rhythm(noteValues: [NoteValue(baseFraction: 1), NoteValue(baseFraction: 2)]),
        Rhythm(noteValues: [NoteValue(baseFraction: 2), NoteValue(baseFraction: 1)]),
        Rhythm(noteValues: [NoteValue(baseFraction: 2, isRest: true), NoteValue(baseFraction: 1)]),
        Rhythm(noteValues: [NoteValue(baseFraction: 1, isRest: true), NoteValue(baseFraction: 2)]),
        Rhythm(noteValues: [NoteValue(baseFraction: 2, dots: 1), NoteValue(baseFraction: 4), NoteValue(baseFraction: 2)]),
    ]
}


enum Sorting {
    case ALPHA
    case DATE
}
