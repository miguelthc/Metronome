//
//  KnobAndButtonsView.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 11/07/2020.
//

import SwiftUI

struct BpmController: View {
    @EnvironmentObject var metronomeEnvironment: MetronomeEnvironment
    
    var body: some View {
        HStack{
            Button(action: metronomeEnvironment.decrementBpm) {
                    Text("-1")
            }.padding(.horizontal)
            .disabled(metronomeEnvironment.metronome.bpm.rounded() == Metronome.minBpm)
            
            KnobView()
                .frame(width: 150, height: 150)
            
            Button(action: metronomeEnvironment.incrementBpm) {
                Text("+1")
            }.padding(.horizontal)
            .disabled(metronomeEnvironment.metronome.bpm.rounded() == Metronome.maxBpm)
        }
    }
}

struct KnobAndButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        BpmController()
    }
}
