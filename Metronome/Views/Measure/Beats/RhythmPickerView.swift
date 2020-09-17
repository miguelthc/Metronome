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
    
    @Binding var showRhythmEditor: Bool
    @Binding var showRhythmPicker: Bool
    
    init(showRhythmPicker: Binding<Bool>, showRhythmEditor: Binding<Bool>){
        _showRhythmPicker = showRhythmPicker
        _showRhythmEditor = showRhythmEditor
        UITableView.appearance().separatorStyle = .none
    }
    
    var body: some View {
        VStack (spacing: 0) {
            //Divider()
            
            List {
                
                HStack{
                    Spacer(minLength: 0)
                    
                    AddRhythmView(showBeatEditor: $showRhythmEditor)
                    
                    ForEach(metronomeRepository.validRhythms(timeSignatureNoteValue: metronomeEnvironment.measure.timeSignature.noteValue, compound: self.metronomeEnvironment.measure.compound).prefix(3)){ rhythm in
                        PickerBeatView(rhythm: rhythm)
                        .onTapGesture {
                            self.metronomeEnvironment.selectRhythm(rhythm: rhythm)
                            self.showRhythmPicker = false
                        }
                    }
                    
                    Spacer(minLength: 0)
                }.frame(height: 65)
                .padding(.vertical, 1)
                
                if(metronomeRepository.validRhythms(timeSignatureNoteValue: metronomeEnvironment.measure.timeSignature.noteValue, compound: self.metronomeEnvironment.measure.compound).count > 3){
                    ForEach(metronomeRepository.validRhythms(timeSignatureNoteValue: metronomeEnvironment.measure.timeSignature.noteValue, compound: self.metronomeEnvironment.measure.compound).suffix(from: 3).chunks(size: 4), id: \.self) { chunk in
                        
                        HStack{
                            Spacer(minLength: 0)
                                                    
                            ForEach(chunk, id: \.self){ rhythm in
                                PickerBeatView(rhythm: rhythm)
                                .onTapGesture {
                                    self.metronomeEnvironment.selectRhythm(rhythm: rhythm)
                                    self.showRhythmPicker = false
                                }
                            }
                            
                            Spacer(minLength: 0)
                        }.frame(height: 65)
                        .padding(.vertical, 1)
                    }
                }
            }
    
            //Divider()
        }
        .padding(.top, 10)
        //.background(Color.white)
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

extension ArraySlice {
    
    func chunks(size: Int) -> [ArraySlice<Element>] {
        var chunks: [ArraySlice<Element>] = [ArraySlice<Element>]()
        
        for index in stride(from: 0, to: self.count - 1, by: size) {
            
            var chunk = ArraySlice<Element>()
            let end = index + size + startIndex
            if end >= self.endIndex {
                chunk = self[(index + startIndex)..<self.endIndex]
            } else {
                chunk = self[(index + startIndex)..<end]
            }
            
            chunks.append(chunk)
            
            if (end + 1) == self.endIndex {
                let remainingChunk = self[end..<self.endIndex]
                chunks.append(remainingChunk)
            }
            
        }
        
        return chunks
    }
}


struct RhythmPickerView_Previews: PreviewProvider {
    static var previews: some View {
        RhythmPickerView(showRhythmPicker: .constant(false), showRhythmEditor: .constant(false))
    }
}
