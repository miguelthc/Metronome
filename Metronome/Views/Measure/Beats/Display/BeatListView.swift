//
//  BeatListView.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 18/07/2020.
//

import SwiftUI

struct BeatListView: View {
    @EnvironmentObject var metronomeEnvironment: MetronomeEnvironment
    @EnvironmentObject var metronomeRepository: MetronomeRepository
    
    @Binding var showRhythmEditor: Bool
    
    var body: some View {
        HStack {
                
            Spacer(minLength: 5)
                
            ForEach(metronomeEnvironment.measure.beats, id: \.id){ beat in
                MeasureBeatView(beat: beat,
                                timeSignatureNoteValue: self.metronomeEnvironment.measure.timeSignature.noteValue,
                                replaceInvalidRhythm: self.metronomeEnvironment.replaceInvalidRhythm)
            
            }
            
            Spacer(minLength: 5)
        }.frame(height: 65)
        .padding(.vertical, 1)
        
        .sheet(isPresented: $showRhythmEditor, onDismiss: {
                    self.metronomeEnvironment.rhythmEditorObject.resetEditor()
                }){
                    RhythmEditorView(showRhythmEditor: self.$showRhythmEditor)
                    .environmentObject(self.metronomeEnvironment)
                    .environmentObject(self.metronomeRepository)
                
                    
            }
    }
}

struct BeatListView_Previews: PreviewProvider {
    static var previews: some View {
        BeatListView(showRhythmEditor: .constant(false))
    }
}
