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
        
    private var noteValueCount = 1
    private var rhythmTimeValues: [[RhythmValue]] = []
    private var bpm: Double = 60.0
    
    private var compound: Bool = false;
    
    private var time: Float = 0.0
    
    private var oldBpm: Double = 0
    private var oldRhythmTimeValues: [[RhythmValue]] = []
    private var rhythmValuesSet = true
    
    private var beepTime: Float = 0.0
    private var beepsToPlay: [RhythmValue] = []
    
    init() {
        audioEngine = AudioEngine(renderFunction: renderFunction)
        audioEngine.setSourceNode(renderFunction: setRenderFunction())
    }
    
    func updateMetronome(metronome: Metronome, wasPlaying: Bool){
        if(wasPlaying){
            rhythmValuesSet = false
            oldBpm = bpm
            oldRhythmTimeValues = rhythmTimeValues
            
            if(metronome.measure.compound != compound){
                compound = metronome.measure.compound
                resetMetornome()
            }
        }
        
        bpm = metronome.bpm.rounded()
        setRhythmValues(metronome: metronome)
        rhythmValuesSet = true

        time = time * Float(oldBpm/bpm)
    }
    
    func resetMetornome(){
        time = 0.0
        beatCount = 1
        noteValueCount = 1
        beatOccured = false
        beepOccured = false
    }
    
    
    private func setRenderFunction() -> (Float, UInt64) -> Float {
    
        let renderFunction = { (deltaTime: Float, _: UInt64) -> Float in
            var sampleValue: Float = 0.0
            let bpm = self.rhythmValuesSet ? self.bpm : self.oldBpm
            let rhythmTimeValues = self.rhythmValuesSet ? self.rhythmTimeValues : self.oldRhythmTimeValues
            
            
            if(self.beatCount > rhythmTimeValues.count){
                self.resetMetornome()
            }
                
            if (rhythmTimeValues[self.beatCount-1].count > 0){
                
                if(rhythmTimeValues[self.beatCount-1].count >= self.noteValueCount && self.time >= rhythmTimeValues[self.beatCount-1][self.noteValueCount-1].timeValue){
                    
                    self.beepsToPlay.append(rhythmTimeValues[self.beatCount-1][self.noteValueCount-1])
                    self.noteValueCount += 1
                }
                
                if(self.beepsToPlay.count > 0){
                    if(self.beepTime < 0.02){
                        let frequency: Float = self.beepsToPlay[0].accent ? 1173.3 : 880.0
                        
                        sampleValue = sin(2.0 * Float.pi * frequency * self.beepTime) * (-pow((100*((self.beepTime) - 0.01)), 8) + 1)

                        self.beepTime += deltaTime
                        
                        if(!self.beepOccured){
                            self.beepOccured = true
                        }
                    }else{
                        self.beepsToPlay.removeFirst()
                        self.beepTime = 0
                    }
                }
            }
               
            self.time += deltaTime
               
            let timeBetweenBeats: Float = 60 / Float(bpm)
               
            if(self.time >= timeBetweenBeats) {
                self.time -= timeBetweenBeats
                self.incrementBeatCount()
            }
        
            return sampleValue
        }
            
        return renderFunction
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
                
                timeSum += Float(noteValue.fractionOfBeat) * timeBetweenBeats * (metronome.measure.compound ? 2/3 : 1)
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
