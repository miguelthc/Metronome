//
//  MeasureView.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 11/07/2020.
//

import SwiftUI

struct MeasureView: View {
    @EnvironmentObject var metronomeEnvironment: MetronomeEnvironment
    
    var body: some View {
        TabView {
            SimpleMeasureView()
            
            BeatMeasureView()
                .frame(height: 80)
            
            SquaresMeasureView()
        }
    }
}

struct BeatMeasureView: View {
    @State var showRhythmPicker: Bool = false
    
    var body: some View {
        VStack{
            MeasureActionButtonsView(showRhythmPicker: $showRhythmPicker)
            
            BeatListView(showRhythmPicker: $showRhythmPicker)
        }
    }
}

struct MeasureView_Previews: PreviewProvider {
    static var previews: some View {
        MeasureView()
    }
}
