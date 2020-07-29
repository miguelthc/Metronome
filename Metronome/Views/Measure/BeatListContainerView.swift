//
//  BeatListContainerView.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 18/07/2020.
//

import SwiftUI

struct BeatListContainerView: View {
    @EnvironmentObject var metronomeEnvironment: MetronomeEnvironment
    
    var body: some View {
        
            BeatListView()
                .frame(height: 79)
                .padding(.bottom, 60)
                .overlay(
                    RhythmPickerView()
                        .offset(y: 60)
                        .opacity(metronomeEnvironment.showBeatEditor ? 1 : 0)
                        .disabled(!metronomeEnvironment.showBeatEditor)
                    )
    }
}

struct BeatListContainerView_Previews: PreviewProvider {
    static var previews: some View {
        BeatListContainerView()
    }
}
