//
//  DAO.swift
//  Metronome
//
//  Created by Miguel Carvalho on 12/08/2020.
//  Copyright © 2020 Miguel Carvalho. All rights reserved.
//

import Foundation
import SQLite

let DATABASE_NAME = "metronome.sqlite"
let SIMPLE_RHYTHM_TABLE = "SimplePickerRhythm"
let COMPOUND_RHYTHM_TABLE = "CompoundPickerRhythm"
let METRONOME_TABLE = "Metronome"

class DAO {
    let db: Connection
    
    let simpleRhythmTable = Table(SIMPLE_RHYTHM_TABLE)
    let compoundRhythmTable = Table(COMPOUND_RHYTHM_TABLE)
    let rhythm = Expression<String>("Rhythm")
    
    let metronomeTable = Table(METRONOME_TABLE)
    let name = Expression<String>("Name")
    let bpm = Expression<Double>("Bpm")
    let timeSignatureNoteCount = Expression<Int>("TimeSignatureNoteCount")
    let timeSignatureNoteValue = Expression<Int>("TimeSignatureNoteValue")
    let compound = Expression<Bool>("Compound")
    let beats = Expression<String>("Beats")
    
    init(){
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        
        db = try! Connection("\(path)/\(DATABASE_NAME)")
        
        createRhythmTables()
        createMetronomeTable()
    }
    
    var metronomeCount: Int {
        try! db.scalar(metronomeTable.count)
    }
    
    
    private func createRhythmTables(){
        let rhythm = Expression<String>("Rhythm")
        
        try! db.run(simpleRhythmTable.create(ifNotExists: true) { t in
            t.column(rhythm, primaryKey: true)
        })
        
        try! db.run(compoundRhythmTable.create(ifNotExists: true) { t in
            t.column(rhythm, primaryKey: true)
        })
    }
    
    private func createMetronomeTable(){
        
        
        try! db.run(metronomeTable.create(ifNotExists: true) { t in
            t.column(name, primaryKey: true)
            t.column(bpm)
            t.column(timeSignatureNoteCount)
            t.column(timeSignatureNoteValue)
            t.column(compound)
            t.column(beats)
        })
    }
    
    func insertSimpleRhythm(rhythmDescription: String){
        try! db.run(simpleRhythmTable.insert(or: .replace, rhythm <- rhythmDescription))
    }
    
    func insertCompoundRhythm(rhythmDescription: String){
        try! db.run(compoundRhythmTable.insert(or: .replace, rhythm <- rhythmDescription))
    }
    
    func selectSimpleRhythms() -> [String]{
        var rhythms: [String] = []
        
        for simpleRhythm in try! db.prepare(simpleRhythmTable) {
            rhythms.append(simpleRhythm[rhythm])
        }
        
        return rhythms
    }
    
    func selectCompoundRhythms() -> [String]{
        var rhythms: [String] = []
        
        for compoundRhythm in try! db.prepare(compoundRhythmTable) {
            rhythms.append(compoundRhythm[rhythm])
        }
        
        return rhythms
    }
    
    func insertMetronome(metronome: StoreMetronome){
        try! db.run(metronomeTable.insert(or: .replace,
                                             name <- metronome.name,
                                             bpm <- metronome.bpm,
                                             timeSignatureNoteCount <- metronome.timeSignatureNoteCount,
                                             timeSignatureNoteValue <- metronome.timeSignatureNoteValue,
                                             compound <- metronome.compound,
                                             beats <- metronome.beats))
    }
    
    func selectMetronomes() -> [StoreMetronome] {
        var metronomes: [StoreMetronome] = []
        
        for storeMetronome in try! db.prepare(metronomeTable) {
            metronomes.append(StoreMetronome(name: storeMetronome[name], bpm: storeMetronome[bpm], timeSignatureNoteCount: storeMetronome[timeSignatureNoteCount], timeSignatureNoteValue: storeMetronome[timeSignatureNoteValue], compound: storeMetronome[compound], beats: storeMetronome[beats]))
        }
        
        return metronomes
    }
    
    func selectMetronome(name: String) -> StoreMetronome? {
        
        let resultMetronome = try! db.prepare(metronomeTable.filter(self.name == name))
        
        for result in resultMetronome {
            return StoreMetronome(
                name: result[self.name],
                bpm: result[bpm],
                timeSignatureNoteCount: result[timeSignatureNoteCount],
                timeSignatureNoteValue: result[timeSignatureNoteValue],
                compound: result[compound],
                beats: result[beats])
        }
        
       return nil
    }
    
    func metronomeExists(name: String) -> Bool {
        let resultMetronome = try! db.prepare(metronomeTable.filter(self.name == name))
        
        for _ in resultMetronome {
            return true
        }
        
        return false
    }
}

struct StoreMetronome {
    let name: String
    let bpm: Double
    let timeSignatureNoteCount: Int
    let timeSignatureNoteValue: Int
    let compound: Bool
    let beats: String
}
