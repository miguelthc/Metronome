////
////  MetronomeRepository.swift
////  Metronome
////
////  Created by Miguel Carvalho on 19/01/2021.
////  Copyright © 2021 Miguel Carvalho. All rights reserved.
////
//
//import Foundation
//import SwiftQLite
//
//let DATABASE_NAME = "metronome"
//let SIMPLE_RHYTHM_TABLE = "SimplePickerRhythm"
//let COMPOUND_RHYTHM_TABLE = "CompoundPickerRhythm"
//let METRONOME_TABLE = "Metronome"
//
//
//
//class Repository {
//    private let database = Database(name: DATABASE_NAME)
//    
//    private let metronomeDao: MetronomeDao
//    private let simpleRhythmDao: RhythmDao
//    private let compoundRhythmDao: RhythmDao
//    
//    init(){
//        initTables()
//    }
//    
//    private func initTables(){
//        let metronomeTable = database.getTable<Metronome>(METRONOME_TABLE, create: true)
//        metronomeDao = MetronomeDao(metronomeTable!)
//    }
//}
