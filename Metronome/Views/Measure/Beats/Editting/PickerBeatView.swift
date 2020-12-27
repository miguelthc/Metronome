//
//  PickerBeatView.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 20/07/2020.
//

import SwiftUI

struct PickerBeatView: View {
    @EnvironmentObject var metronomeEnvironment: MetronomeEnvironment
    
    let rhythm: Rhythm
    
    var body: some View {
        BeatView(rhythm: rhythm,
                 timeSignatureNoteValue: metronomeEnvironment.measure.timeSignature.noteValue,
                 compound: metronomeEnvironment.measure.compound
        )
    }
}

struct PickerBeatView_Previews: PreviewProvider {
    static var previews: some View {
        PickerBeatView(rhythm: Rhythm())
    }
}
