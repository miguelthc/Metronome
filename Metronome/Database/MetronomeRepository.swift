//
//  MetronomeRepository.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 18/07/2020.
//

import Foundation
import CoreData

class MetronomeRepository: ObservableObject {
    @Published var simplePickerRhythms: [Rhythm] = []
    @Published var compoundPickerRhythms: [Rhythm] = []
    
    let pickerRhythmDao: DAO
    
    init(){
        pickerRhythmDao = DAO()
        pickerRhythmDao.openDatabase()
        
        if !pickerRhythmDao.tablesExist() {
            pickerRhythmDao.createTables()
            
            for rhythm in MetronomeRepository.initialSimpleRhythms {
                addPickerRhythm(rhythm: rhythm, compound: false)
            }
            
            for rhythm in MetronomeRepository.initialCompoundRhythms {
                addPickerRhythm(rhythm: rhythm, compound: true)
            }
        }
        
        simplePickerRhythms = loadSimplePickerRhythms()
        compoundPickerRhythms = loadCompoundPickerRhythms()
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
}

extension MetronomeRepository {
    private func addPickerRhythm(rhythm: Rhythm, compound: Bool){
        var rhythmDescription = ""
        
        for noteValue in rhythm.noteValues {
            rhythmDescription.append("\(noteValue.baseFraction) \(noteValue.isRest) \(noteValue.accent) \(noteValue.dots)\n")
        }
        
        if(compound){
            pickerRhythmDao.insertCompoundRhythm(rhythmDescription: rhythmDescription)
        }else{
            pickerRhythmDao.insertSimpleRhythm(rhythmDescription: rhythmDescription)
        }
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
    
    private func loadSimplePickerRhythms() -> [Rhythm] {
        var pickerRhythms: [Rhythm] = []
        
        for description in pickerRhythmDao.selectSimpleRhythms() {
            pickerRhythms.append(descriptionToRhythm(description: description))
        }
        
        return pickerRhythms
    }
    
    private func loadCompoundPickerRhythms() -> [Rhythm] {
        var pickerRhythms: [Rhythm] = []
        
        for description in pickerRhythmDao.selectCompoundRhythms() {
            pickerRhythms.append(descriptionToRhythm(description: description))
        }
        
        return pickerRhythms
    }
    
    static let initialSimpleRhythms: [Rhythm] = [
            Rhythm(),
            Rhythm(noteValues: [NoteValue(baseFraction: 1, isRest: true)]),
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
        Rhythm(noteValues: [NoteValue(baseFraction: 1, isRest: true, dots: 1)]),
        Rhythm(noteValues: [NoteValue(baseFraction: 2), NoteValue(baseFraction: 2), NoteValue(baseFraction: 2)]),
        Rhythm(noteValues: [NoteValue(baseFraction: 1), NoteValue(baseFraction: 2)]),
        Rhythm(noteValues: [NoteValue(baseFraction: 2), NoteValue(baseFraction: 1)]),
        Rhythm(noteValues: [NoteValue(baseFraction: 2, isRest: true), NoteValue(baseFraction: 1)]),
        Rhythm(noteValues: [NoteValue(baseFraction: 1, isRest: true), NoteValue(baseFraction: 2)]),
        Rhythm(noteValues: [NoteValue(baseFraction: 2, dots: 1), NoteValue(baseFraction: 4), NoteValue(baseFraction: 2)]),
    ]
}
