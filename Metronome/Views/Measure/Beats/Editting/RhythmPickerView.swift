//
//  RhythmPickerView.swift
//  Metronome
//
//  Created by Miguel Carvalho on 22/09/2020.
//  Copyright © 2020 Miguel Carvalho. All rights reserved.
//

import SwiftUI

struct RhythmPickerView: View {
    @EnvironmentObject var metronomeEnvironment: MetronomeEnvironment
    @EnvironmentObject var metronomeRepository: MetronomeRepository
    
    @Binding var showRhythmEditor: Bool
    
    @State private var expanded = false
    
    var body: some View {
        VStack (spacing: 0){
            Divider()
            
            HStack {
                Button(action: {
                    metronomeEnvironment.rhythmEditorObject.compound = metronomeEnvironment.measure.compound
                    self.showRhythmEditor = true
                }){ Image(systemName: "plus") }
                
                Spacer()
                
                Button(action: {
                    metronomeEnvironment.rhythmEditorObject.compound = metronomeEnvironment.measure.compound
                    expanded.toggle()
                }){ Image(systemName: "chevron.down.circle") }
            }.padding(.horizontal)
            .padding(.vertical, 5)
            
            
            if(expanded){
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 65, maximum: 65))]){
                        content()
                    }
                    .padding(.top, 2)
                    .padding(.horizontal, 5)
                    
                }
            }else{
                ScrollView (.horizontal){
                    LazyHGrid(rows: [GridItem(.fixed(65))]){
                        content()
                    }
                    .padding(.top, 2)
                    .padding(.bottom, 14)
                    .padding(.horizontal, 5)
                }
            }
            
            Divider()
        }
    }
    
    func content() -> AnyView {
        return AnyView (Group {
            ForEach(metronomeRepository.validRhythms(timeSignatureNoteValue: metronomeEnvironment.measure.timeSignature.noteValue, compound: self.metronomeEnvironment.measure.compound)){ rhythm in
                
                PickerBeatView(rhythm: rhythm)
                    .onTapGesture {
                        self.metronomeEnvironment.selectRhythm(rhythm: rhythm)
                    }
            }
        })
    }
}

struct AddRhythmView: View {
    @EnvironmentObject var metronomeEnvironment: MetronomeEnvironment
    @Binding var showBeatEditor: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 6).stroke(lineWidth: 2)
            .aspectRatio(1, contentMode: .fit)
            .overlay(
                Button(action: {
                    self.metronomeEnvironment.rhythmEditorObject.compound = self.metronomeEnvironment.measure.compound
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
        RhythmPickerView(showRhythmEditor: .constant(false))
    }
}
