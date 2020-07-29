//
//  BeatView.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 18/07/2020.
//

import SwiftUI

struct BeatView: View {
    let rhythm: Rhythm
    let timeSignatureNoteValue: NoteValueFraction
    var selected: Bool = false
    var secondSelected: Bool = false
    var isValid = true
    
    var body: some View {
        RoundedRectangle(cornerRadius: 6)
            .aspectRatio(1, contentMode: .fit)
            .modifier(BeatModifier(selected: selected, secondSelected: secondSelected, validRhythm: isValid))
            .overlay(RhythmView(rhythm: rhythm, timeSignatureNoteValue: timeSignatureNoteValue))
    }
}

struct BeatModifier: ViewModifier {
    var selected: Bool = false
    var secondSelected: Bool = false
    var validRhythm: Bool = true
    
    func body(content: Content) -> some View {
        content
            .opacity(0)
            .overlay(RoundedRectangle(cornerRadius: 6)
                        .stroke((selected ? (secondSelected ? Color.green : Color.blue) : Color.black), lineWidth: 2)
            )
            
            .overlay(RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.red, lineWidth: 1.5)
                        .opacity(validRhythm ? 0 : 1)
                        .frame(width: 63, height: 63    )
                        .aspectRatio(1, contentMode: .fit)
                        
            )
    }
}

struct BeatView_Previews: PreviewProvider {
    static var previews: some View {
        BeatView(rhythm: Rhythm(), timeSignatureNoteValue: .QUARTER, selected: false)
    }
}
