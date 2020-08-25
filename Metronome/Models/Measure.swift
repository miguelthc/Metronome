//
//  Measure.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 12/07/2020.
//

import Foundation

struct Measure {
    var timeSignature: TimeSignature = TimeSignature()
    var beats: [Beat] = Measure.defaultSimpleMeasure()
    var compound: Bool = false
    
    var noteCountIsMultipleOf3: Bool {
        timeSignature.noteCount.isMultiple(of: 3) && !(timeSignature.noteValue == .WHOLE)
    }
    
    var beatsPerMeasure: Int {
        compound ? timeSignature.noteCount/3 : timeSignature.noteCount
    }
}

struct TimeSignature {
    var noteCount: Int = 4
    var noteValue: NoteValueFraction = .QUARTER
}

extension Measure {
    static let minBeatsPerMeasure = 1
    static let maxBeatsPerMeasure = 16
    
    func defaultBeat() -> Rhythm {
        if(!compound){
            return Rhythm()
        }else{
            return Rhythm(noteValues: [NoteValue(baseFraction: 1, isRest: false, accent: false, dots: 1)])
        }
    }
    
    static func defaultSimpleMeasure() -> [Beat] {
        var beatsInMeasure: [Beat] = []
        
        for i in 1...4 {
            beatsInMeasure.append(Beat(id: i, rhythm: Rhythm()))
        }
        
        return beatsInMeasure
    }
}
