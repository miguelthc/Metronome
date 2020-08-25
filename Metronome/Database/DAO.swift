//
//  DAO.swift
//  Metronome
//
//  Created by Miguel Carvalho on 12/08/2020.
//  Copyright © 2020 Miguel Carvalho. All rights reserved.
//

import Foundation
import SQLite3

class DAO {
    var db: OpaquePointer?
    var dbOpen: Bool = false
    
    func openDatabase() {
        let directoryUrl = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        guard let dbPath = directoryUrl?.appendingPathComponent("metronome.sqlite").relativePath else {
            return
        }
        
        if sqlite3_open(dbPath, &db) != SQLITE_OK {
            sqlite3_close(db)
        }
        
        dbOpen = true
    }
    
    func createTables() {
        var createTableStatement: OpaquePointer?
        
        let createSimpleTableString: String = """
        CREATE TABLE SimplePickerRhythm(
        Rhythm TEXT PRIMARY KEY NOT NULL);
        """
        
        sqlite3_prepare_v2(db, createSimpleTableString, -1, &createTableStatement, nil)
        sqlite3_step(createTableStatement)
        sqlite3_finalize(createTableStatement)
        
        let createCompoundTableString: String = """
        CREATE TABLE CompoundPickerRhythm(
        Rhythm TEXT PRIMARY KEY NOT NULL);
        """
        
        sqlite3_prepare_v2(db, createCompoundTableString, -1, &createTableStatement, nil)
        sqlite3_step(createTableStatement)
        sqlite3_finalize(createTableStatement)
    }
    
    func tablesExist() -> Bool {
        var tableExistsStatement: OpaquePointer?
        let exists: Bool
        
        let tableExistsString = "SELECT name FROM sqlite_master WHERE type='table' AND name='SimplePickerRhythm';"
        
        sqlite3_prepare_v2(db, tableExistsString, -1, &tableExistsStatement, nil)
        
        if(sqlite3_step(tableExistsStatement) == SQLITE_ROW){
            exists = true
        }else{
            exists = false
        }
        
        sqlite3_finalize(tableExistsStatement)
        
        return exists
    }
    
    
    func insertSimpleRhythm(rhythmDescription: String) {
        var insertStatement: OpaquePointer?
      
        let insertStatementString = "INSERT INTO SimplePickerRhythm (Rhythm) VALUES (?);"
        
        sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil)

        sqlite3_bind_text(insertStatement, 1, NSString(string: rhythmDescription).utf8String, -1, nil)
        
        sqlite3_step(insertStatement)
    
        sqlite3_finalize(insertStatement)
    }
    
    func insertCompoundRhythm(rhythmDescription: String) {
        var insertStatement: OpaquePointer?
      
        let insertStatementString = "INSERT INTO CompoundPickerRhythm (Rhythm) VALUES (?);"
        
        sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil)

        sqlite3_bind_text(insertStatement, 1, NSString(string: rhythmDescription).utf8String, -1, nil)
        
        sqlite3_step(insertStatement)
    
        sqlite3_finalize(insertStatement)
    }
    
    func selectSimpleRhythms() -> [String] {
        var queryStatement: OpaquePointer?
        
        let queryStatementString = "SELECT * FROM SimplePickerRhythm;"
        
        sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil)
        
        var rhythmDescriptions: [String] = []
        
        while(sqlite3_step(queryStatement) == SQLITE_ROW){
            rhythmDescriptions.append(String(cString: sqlite3_column_text(queryStatement, 0)))
        }
        
        sqlite3_finalize(queryStatement)
        
        return rhythmDescriptions
    }
    
    func selectCompoundRhythms() -> [String] {
        var queryStatement: OpaquePointer?
        
        let queryStatementString = "SELECT * FROM CompoundPickerRhythm;"
        
        sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil)
        
        var rhythmDescriptions: [String] = []
        
        while(sqlite3_step(queryStatement) == SQLITE_ROW){
            rhythmDescriptions.append(String(cString: sqlite3_column_text(queryStatement, 0)))
        }
        
        sqlite3_finalize(queryStatement)
        
        return rhythmDescriptions
    }
    
    func closeDatabase(){
        sqlite3_close(db)
        dbOpen = false
    }
}
