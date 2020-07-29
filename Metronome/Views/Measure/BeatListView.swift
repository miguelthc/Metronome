//
//  BeatListView.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 18/07/2020.
//

import SwiftUI

struct BeatListView: View {
    @EnvironmentObject var metronomeEnvironment: MetronomeEnvironment
    
    var body: some View {
        GeometryReader { geometry in
            if(self.metronomeEnvironment.beatListZoomed && geometry.size.width < CGFloat(self.metronomeEnvironment.beatListSize)){
                ScrollView (.horizontal){
                    BeatList()
                }
            }else{
                BeatList()
            }
        }
    }
    
    func beatsDontFitScreen() -> Bool {
        return false
    }
}
    
struct BeatList: View {
    @EnvironmentObject var metronomeEnvironment: MetronomeEnvironment
    
    var body: some View{
        HStack {
                
            Spacer(minLength: 4)
                
            ForEach(metronomeEnvironment.measure.beats, id: \.id){ beat in
                MeasureBeatView(beat: beat,
                                timeSignatureNoteValue: self.metronomeEnvironment.measure.timeSignatureNoteValue,
                                replaceInvalidRhythm: self.metronomeEnvironment.replaceInvalidRhythm)
            
            }
            
            Spacer(minLength: 4)
        }.frame(height: 65).padding(.bottom, 14).padding(.top, 1)
    }
}

struct BeatListView_Previews: PreviewProvider {
    static var previews: some View {
        BeatListView()
    }
}
