//
//  Measure.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 12/07/2020.
//

import Foundation

struct Measure {
    var timeSignatureNoteValue: NoteValueFraction = .QUARTER
    var beats: [Beat] = Measure.defaultMeasure()
    
    var beatsPerMeasure: Int {
        get {
            return beats.count
        }
    }
}

extension Measure {
    static let minBeatsPerMeasure = 1
    static let maxBeatsPerMeasure = 16
    
    static func defaultMeasure() -> [Beat] {
        var beatsInMeasure: [Beat] = []
        
        for i in 1...4 {
            beatsInMeasure.append(Beat(id: i, rhythm: Rhythm()))
        }
        
        return beatsInMeasure
    }
}
