//
//  ContentView.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 11/07/2020.
//

import SwiftUI

struct MetronomeView: View {
    @EnvironmentObject var metronomeEnvironment: MetronomeEnvironment
    
    var body: some View {
        VStack {
            
            Spacer()
            
            MeasureView()
            
            Spacer()
            
            BpmView(bpm: metronomeEnvironment.bpm)
                        
            Spacer()
            
            HStack {
                TimeSignatureView()
                
                Spacer()
                
                BeatValueView()
                    .onTapGesture {
                    self.metronomeEnvironment.toggleCompoundMeasure()
                    }
                    .disabled(!metronomeEnvironment.measure.noteCountIsMultipleOf3)
            }
            
            BpmController()
            
            HStack {
                PlayView()
                
                Spacer()
                
                TapView()
            }.padding(.bottom, 16)
        }
    }
}

struct MetronomeView_Previews: PreviewProvider {
    static var previews: some View {
        MetronomeView()
    }
}
