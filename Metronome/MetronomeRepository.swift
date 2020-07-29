//
//  MetronomeRepository.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 18/07/2020.
//

import Foundation

class MetronomeRepository: ObservableObject {
    
    @Published var beatEditorRhythms: [Rhythm] = []
    
    init(){
        beatEditorRhythms = loadBeatEditorRhythms()
    }
    
    func addRhythm(rhythm: Rhythm){
        var i: Int = 0
        var repeated: Bool = false
        
        for repRhythm in beatEditorRhythms {
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
            beatEditorRhythms.append(rhythm)
        }
    }
}

extension MetronomeRepository {
    private func loadBeatEditorRhythms() -> [Rhythm] {
        return [
            Rhythm(),
            Rhythm(noteValues: [NoteValue(baseFraction: 2), NoteValue(baseFraction: 2)]),
            Rhythm(noteValues: [NoteValue(baseFraction: 2), NoteValue(baseFraction: 4), NoteValue(baseFraction: 4)]),
            Rhythm(noteValues: [NoteValue(baseFraction: 4), NoteValue(baseFraction: 2), NoteValue(baseFraction: 4)]),
            Rhythm(noteValues: [NoteValue(baseFraction: 4), NoteValue(baseFraction: 4), NoteValue(baseFraction: 2)]),
            Rhythm(noteValues: [NoteValue(baseFraction: 4), NoteValue(baseFraction: 4), NoteValue(baseFraction: 4), NoteValue(baseFraction: 4)])
        ]
    }
}
