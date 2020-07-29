//
//  RhythmPickerView.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 18/07/2020.
//

import SwiftUI

struct RhythmPickerView: View {
    @EnvironmentObject var metronomeEnvironment: MetronomeEnvironment
    @EnvironmentObject var metronomeRepository: MetronomeRepository
    
    @State var showBeatEditor: Bool = false
    
    var body: some View {
        VStack (spacing: 0) {
            Divider()
            
            ScrollView (.horizontal){
                                
                HStack (spacing: 6) {
                    AddRhythmView(showBeatEditor: $showBeatEditor)
                    
                    ForEach(metronomeRepository.beatEditorRhythms, id: \.id) { rhythm in
                        Group{
                            if rhythm.isValid(timeSignatureNoteValue: self.metronomeEnvironment.measure.timeSignatureNoteValue){
                                
                                PickerBeatView(rhythm: rhythm)
                                
                            }
                        }
                    }
                }.frame(height: 65)
                .padding(.vertical, 14)
                .padding(.horizontal, 4)
            }
    
            Divider()
        }.sheet(isPresented: $showBeatEditor) {
            RhythmEditorView(showBeatEditor: self.$showBeatEditor)
                .environmentObject(self.metronomeEnvironment)
                .environmentObject(self.metronomeRepository)
                .environmentObject(RhythmEditorObject(timeSignatureNoteValue: self.metronomeEnvironment.measure.timeSignatureNoteValue))
        }
        .background(Color.white)
    }
}

struct AddRhythmView: View {
    @Binding var showBeatEditor: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 6).stroke(lineWidth: 2)
            .aspectRatio(1, contentMode: .fit)
            .overlay(
                Button(action: {
                    self.showBeatEditor = true
                }){
                    Image(systemName: "plus")
                        .font(.system(size: 30))
                }
            )
    }
}

struct RhythmPickerView_Previews: PreviewProvider {
    static var previews: some View {
        RhythmPickerView()
    }
}
