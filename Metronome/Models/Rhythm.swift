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

extension Rhythm: Hashable {
    static func == (lhs: Rhythm, rhs: Rhythm) -> Bool {
        return lhs.id == rhs.id && lhs.noteValues == rhs.noteValues
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(noteValues)
    }
}
