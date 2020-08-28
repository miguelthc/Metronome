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
            
            HStack{
                Button(action: {self.metronomeEnvironment.measureType = MeasureType.Simple}){
                    Image(systemName: "circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                        
                }.disabled(metronomeEnvironment.measureType == MeasureType.Simple)
                    .padding(.horizontal, 5)
                
                Button(action: {self.metronomeEnvironment.measureType = MeasureType.Beats}){
                    GeometryReader{ geometry in
                        RhythmView(rhythm: Rhythm(), timeSignatureNoteValue: .QUARTER, geometry: geometry.size)
                    }.frame(width: 20, height: 20)
                    
                }.disabled(metronomeEnvironment.measureType == MeasureType.Beats)
                .padding(.horizontal, 5)
                
                Button(action: {self.metronomeEnvironment.measureType = MeasureType.Square}){
                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 20, height: 20)
                }.disabled(metronomeEnvironment.measureType == MeasureType.Square)
                .padding(.horizontal, 5)
            }.padding(.top, 5)
            
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
