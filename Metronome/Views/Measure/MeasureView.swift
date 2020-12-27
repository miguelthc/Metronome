//
//  MeasureView.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 11/07/2020.
//

import SwiftUI

struct MeasureView: View {
    @EnvironmentObject var metronomeEnvironment: MetronomeEnvironment
    
    @State var showRhythmEditor: Bool = false
    @State var expanded: Bool = false
    
    var body: some View {
        VStack{
            
            HStack{
                Button(action: {self.metronomeEnvironment.measureType = MeasureType.Simple}){
                    Image(systemName: "circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                }.disabled(metronomeEnvironment.measureType == MeasureType.Simple)
                .padding(.horizontal, 5)
                                
                Button(action: {self.metronomeEnvironment.measureType = MeasureType.Beats}){
                    RhythmView(rhythm: Rhythm(), timeSignatureNoteValue: .QUARTER, geometry: CGSize(width: 20/3.13, height: 20))
                }.disabled(metronomeEnvironment.measureType == MeasureType.Beats)
                .padding(.horizontal, 5)
                                
                Button(action: {self.metronomeEnvironment.measureType = MeasureType.Square}){
                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 20, height: 20)
                    }.disabled(metronomeEnvironment.measureType == MeasureType.Square)
                .padding(.horizontal, 5)
            }
            
            
            
            TabView (selection: $metronomeEnvironment.measureType){
                
                SimpleMeasureView()
                    .tag(MeasureType.Simple)
                
                BeatMeasureView(showRhythmEditor: $showRhythmEditor)
                    .tag(MeasureType.Beats)
                
                SquaresMeasureView()
                    .tag(MeasureType.Square)
                
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 110)
            .overlay(
                Group{
                    if(metronomeEnvironment.selectedBeats.count > 0){
                        if(expanded){
                            RhythmPickerView(showRhythmEditor: $showRhythmEditor)
                                .offset(y: 110)
                        }else{
                            RhythmPickerView(showRhythmEditor: $showRhythmEditor)
                                .offset(y: 110)
                                .frame(height: 100)
                        }
                        
                    }
                }
            )
        }
    }
}

struct BeatMeasureView: View {
    @Binding var showRhythmEditor: Bool
    
    var body: some View {
        VStack{
            MeasureActionButtonsView()
                .padding(.vertical, 5)
            
            BeatListView(showRhythmEditor: $showRhythmEditor)
        }
    }
}

struct MeasureView_Previews: PreviewProvider {
    static var previews: some View {
        MeasureView()
    }
}
