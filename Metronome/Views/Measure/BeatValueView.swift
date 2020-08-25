//
//  BeatValueView.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 11/07/2020.
//

import SwiftUI

struct BeatValueView: View {
    @EnvironmentObject var metronomeEnvironment: MetronomeEnvironment
    
    var body: some View {
        RhythmView(rhythm:
                !metronomeEnvironment.measure.compound ?
                            Rhythm() :
                    Rhythm(noteValues: [NoteValue(baseFraction: 1, isRest: false, accent: false, dots: 1)]),
                    timeSignatureNoteValue: metronomeEnvironment.measure.timeSignature.noteValue,
                    compound: metronomeEnvironment.measure.compound,
                    geometry: CGSize(width: 60, height: 60),
                    maxHeight: 28)
            .opacity(metronomeEnvironment.measure.noteCountIsMultipleOf3 ? 1 : 0.5)
            .modifier(BeatValueStyle())
    }
}

struct BeatValueStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 60, height: 60)
            .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(Color(red: 50/255, green: 50/255, blue: 50/255), lineWidth: 1)
                .shadow(color: Color.black, radius: 0.5))
            .padding(.horizontal, 25)
    }
}

struct BeatValueView_Previews: PreviewProvider {
    static var previews: some View {
        BeatValueView()
    }
}
