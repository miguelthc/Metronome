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
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Binding var showRhythmPicker: Bool
    @State var showRhythmEditor: Bool = false
    
    var body: some View {
        HStack {
                
            Spacer(minLength: 4)
                
            ForEach(metronomeEnvironment.measure.beats, id: \.id){ beat in
                MeasureBeatView(beat: beat,
                                timeSignatureNoteValue: self.metronomeEnvironment.measure.timeSignature.noteValue,
                                replaceInvalidRhythm: self.metronomeEnvironment.replaceInvalidRhythm)
            
            }
            
            Spacer(minLength: 4)
        }.frame(height: 65).padding(.vertical, 1)
            .sheet(isPresented: $showRhythmPicker, onDismiss: {
                    self.showRhythmEditor = false
                    self.metronomeEnvironment.rhythmEditorObject.resetEditor()
                }){
                    
                if(self.showRhythmEditor){
                    RhythmEditorView(showRhythmEditor: self.$showRhythmEditor, showRhythmPicker: self.$showRhythmPicker)
                    .environment(\.managedObjectContext, self.managedObjectContext)
                    .environmentObject(self.metronomeEnvironment)
                    .environmentObject(self.metronomeRepository)
                }else{
                    RhythmPickerView(showRhythmPicker: self.$showRhythmPicker, showRhythmEditor: self.$showRhythmEditor)
                    .environment(\.managedObjectContext, self.managedObjectContext)
                    .environmentObject(self.metronomeEnvironment)
                    .environmentObject(self.metronomeRepository)
                }
                
        }
    }
}

struct BeatListView_Previews: PreviewProvider {
    static var previews: some View {
        BeatListView(showRhythmPicker: .constant(false))
    }
}
