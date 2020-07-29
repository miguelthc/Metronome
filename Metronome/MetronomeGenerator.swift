//
//  MetronomeGenerator.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 12/07/2020.
//

import Foundation

class MetronomeGenerator: ObservableObject {
    private let audioEngine: AudioEngine
    private var renderFunction: (Float, UInt64) -> Float = { (_: Float, _: UInt64) -> Float in 0.0 }
    
    @Published var beepOccured: Bool = false
    @Published var beatCount: Int = 1
    @Published var beatOccured: Bool = false
    
    private var incrementBeep: Bool = false
    private var timeToNextBeepSet: Bool = false
    
    private var noteValueCount = 1
    private var rhythmTimeValues: [[RhythmValue]] = []
    
    private var time: Float = 0.0
    
    init() {
        audioEngine = AudioEngine(renderFunction: renderFunction)
    }
    
    func updateMetronome(metronome: Metronome){
        setRhythmValues(metronome: metronome)
        setRenderFunction(bpm: metronome.bpm)
        audioEngine.newSourceNode(renderFunction: self.renderFunction)
    }
    
    func resetMetornome(){
        time = 0.0
        beatCount = 1
        noteValueCount = 1
        beatOccured = false
        beepOccured = false
        incrementBeep = false
    }
 
    
    private func setRenderFunction(bpm: Double){
        
        let timeBetweenBeats: Float = 60 / Float(bpm)
        
        renderFunction = { (deltaTime: Float, _: UInt64) -> Float in
            let sampleValue: Float
            
            if(self.beatCount > self.rhythmTimeValues.count){
                self.resetMetornome()
            }
            
            if (self.rhythmTimeValues[self.beatCount-1].count > 0){
                let noteValueTime = Float(self.rhythmTimeValues[self.beatCount-1][self.noteValueCount-1].timeValue)
                let frequency: Float = self.rhythmTimeValues[self.beatCount-1][self.noteValueCount-1].accent ? 1173.3 : 880.0
                
                if (self.time >= noteValueTime && self.time <= noteValueTime + 0.02){
                                        
                    sampleValue = sin(2.0 * Float.pi * frequency * (self.time-noteValueTime)) * (-pow((100*((self.time-noteValueTime) - 0.01)), 8) + 1)
                    
                    if(!self.beepOccured){
                        self.beepOccured = true
                        self.incrementBeep = true
                    }
                }else{
                    sampleValue = 0.0
                    
                    if(self.incrementBeep){
                        if(self.rhythmTimeValues[self.beatCount-1].count > self.noteValueCount){
                            self.noteValueCount += 1
                            self.incrementBeep = false
                            self.timeToNextBeepSet = false
                        }
                    }
                }
            }else{
                sampleValue = 0.0
            }
            
            self.time += deltaTime
            
            if(self.time >= timeBetweenBeats) {
                self.time -= timeBetweenBeats
                self.incrementBeatCount()
            }
            
            return sampleValue
        }
    }
    
    
    func setRhythmValues(metronome: Metronome){
        let timeBetweenBeats: Float = 60 / Float(metronome.bpm)
        var newRhythmValues: [[RhythmValue]] = []
        
        for beat in metronome.measure.beats {
            var timeSum: Float = 0
            
            for noteValue in beat.rhythm.noteValues{
                //append
                if(newRhythmValues.count < beat.id){
                    newRhythmValues.insert([], at: beat.id-1)
                }
                
                if(!noteValue.isRest){
                    newRhythmValues[beat.id-1].append(RhythmValue(timeValue: timeSum, accent: noteValue.accent))
                }
                
                timeSum += Float(noteValue.fractionOfBeat) * timeBetweenBeats
            }
        }
        
        rhythmTimeValues = newRhythmValues
    }
    
    struct RhythmValue {
        let timeValue: Float
        let accent: Bool
    }
    
    
    func playMetronome(){
        audioEngine.startEngine()
        beatOccured = true
    }
    
    func stopMetronome() {
        audioEngine.stopEngine()
        resetMetornome()
    }
    
    private func incrementBeatCount(){
        if (self.beatCount >= self.rhythmTimeValues.count) {
            self.beatCount = 1
        }else {
            self.beatCount += 1
        }
        
        beatOccured = true
        self.noteValueCount = 1
    }
}
