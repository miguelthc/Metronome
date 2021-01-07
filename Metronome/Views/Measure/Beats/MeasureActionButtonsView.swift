//
//  MeasureActionButtons.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 18/07/2020.
//

import SwiftUI

struct MeasureActionButtonsView: View {
    @EnvironmentObject var metronomeEnvironment: MetronomeEnvironment
    
    @Binding var showRhythmPicker: Bool
        
    var body: some View {
            HStack{
                
                if(!self.metronomeEnvironment.allBeatsSelected){
                    Button(action: self.metronomeEnvironment.selectAll){
                        Text("Select all")
                    }
                }else{
                    Button(action: self.metronomeEnvironment.unselectAll){
                        Text("Unselect all")
                    }
                }
                
                /*
                 
                 Button(action: self.metronomeEnvironment.zoomBeats){
                    Image(systemName: "magnifyingglass")
                }.disabled(geometry.size.width > CGFloat(self.metronomeEnvironment.beatListSize))
                 
                 */
                
                Spacer()

                Button(action: self.metronomeEnvironment.duplicateBeat){
                    Text("Duplicate")
                }.disabled(self.metronomeEnvironment.selectedBeats.count != 1 || self.metronomeEnvironment.measure.beats.count == Measure.maxBeatsPerMeasure)
                
                Button(action: self.metronomeEnvironment.deleteSelectedBeats){
                    Image(systemName: "trash")
                }.disabled(self.metronomeEnvironment.selectedBeats.count == 0 || self.metronomeEnvironment.selectedBeats.count == self.metronomeEnvironment.measure.beatsPerMeasure)
                
                Button(action: {self.showRhythmPicker = true}){
                    Text("Edit")
                }.disabled(self.metronomeEnvironment.selectedBeats.count == 0)
                
                /*
                 
                Button(action: {}){
                    Text("Reorder")
                }
                 
                */
                
            }.padding(.horizontal)
                .padding(.vertical, 2)
    }
}

struct MeasureActionButtons_Previews: PreviewProvider {
    static var previews: some View {
        MeasureActionButtonsView(showRhythmPicker: .constant(false))
    }
}
