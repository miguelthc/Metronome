//
//  Rhythm.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 12/07/2020.
//

import Foundation

struct Rhythm: Identifiable {
    var id = UUID()
    var noteValues: [NoteValue] = [NoteValue()]
}

extension Rhythm {
    func isValid(timeSignatureNoteValue: NoteValueFraction) -> Bool {
        for noteValue in noteValues {
            if noteValue.baseFraction * timeSignatureNoteValue.rawValue > NoteValueFraction.MAX_FRACTION.rawValue {
                return false
            }
        }
        
        return true
    }
}
