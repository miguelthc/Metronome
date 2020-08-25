//
//  RhythmEditorView.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 21/07/2020.
//

import SwiftUI

class RhythmEditorObject: ObservableObject {
    @Published var rhythm: Rhythm = Rhythm(noteValues: [])
    
    @Published var rest: Bool = false
    @Published var accent: Bool = false
    @Published var dot: Bool = false
    @Published var dotNum: Int = 1
    
    var compound: Bool = false
    
    func clearRhythm(){
        rhythm.noteValues = []
    }
    
    func rhythmComplete() -> Bool{
        return currentlyOccupied() == (compound ? 1.5 : 1)
    }
    
    private func currentlyOccupied() -> Double{
        var occupied = 0.0
        
        for noteValue in rhythm.noteValues {
            occupied += noteValue.fractionOfBeat // If fraction is too high precision is lost
        }
        
        return occupied
    }
    
    func noteValueFits(noteValue: NoteValueFraction, timeSignatureNoteValue: NoteValueFraction) -> Bool {
        var occupied = currentlyOccupied()
        
        let baseFraction = noteValue.rawValue/(compound ? timeSignatureNoteValue.rawValue/2 : timeSignatureNoteValue.rawValue)
        
        occupied += 1.0/Double(baseFraction)
        
        if(dot){
            occupied += NoteValue.dotSum(baseFraction: baseFraction, dots: dotNum)
        }
        
        return occupied <= (compound ? 1.5 : 1 ) && (!dot || noteValue.rawValue < NoteValueFraction.SIXTY_FOURTH.rawValue)
    }
    
    func addNoteValue(noteValueFraction: NoteValueFraction, timeSignatureNoteValue: NoteValueFraction) {
        let baseFraction = noteValueFraction.rawValue/(compound ? timeSignatureNoteValue.rawValue/2 : timeSignatureNoteValue.rawValue)
        
        let noteValue = NoteValue(baseFraction: baseFraction, isRest: rest, accent: accent , dots: dot ? dotNum : 0)
        
        rhythm.noteValues.append(noteValue)
    }
    
    func resetEditor(){
        rhythm = Rhythm(noteValues: [])
        rest = false
        accent = false
        dot = false
        dotNum = 1
    }
}

struct RhythmEditorView: View {
    @EnvironmentObject var metronomeEnvironment: MetronomeEnvironment
    @EnvironmentObject var metronomeRepository: MetronomeRepository
    
    @Binding var showRhythmEditor: Bool
    @Binding var showRhythmPicker: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack {

                HStack {
                    Spacer()
                    
                    Button(action: self.metronomeEnvironment.rhythmEditorObject.clearRhythm){
                        Text("Clear")
                    }.padding()
                }
                
                RhythmDisplay()

                Spacer()

                NoteValueList(geometryWidth: geometry.size.width)
                                
                HStack{

                    Spacer()

                    RestToggle()

                    Spacer()

                    AccentToggle()

                    Spacer()
                    
                    DotToggle()
                    
                    Spacer()

                }.padding()

                Spacer()
                 
                Button(action: {
                    self.addRhythm()
                    self.showRhythmPicker = false
                    self.showRhythmEditor = false
                }){
                    Image(systemName: "plus")
                        .font(.system(size: 30))
                        .frame(width: 60, height: 60)
                }.disabled(!self.metronomeEnvironment.rhythmEditorObject.rhythmComplete())
            }
        }
    }
    
    func addRhythm(){
        metronomeRepository.addRhythm(rhythm: metronomeEnvironment.rhythmEditorObject.rhythm, compound: metronomeEnvironment.measure.compound)
        metronomeEnvironment.selectRhythm(rhythm: metronomeEnvironment.rhythmEditorObject.rhythm)
        metronomeEnvironment.rhythmEditorObject.resetEditor()
    }
}

struct RhythmDisplay: View {
    @EnvironmentObject var metronomeEnvironment: MetronomeEnvironment
    
    let rhythmDisplayMaxHeight: CGFloat = 50
    
    var body: some View {
        HStack{
            Spacer()
            
            GeometryReader{ geometry in
                RhythmView(rhythm: self.metronomeEnvironment.rhythmEditorObject.rhythm, timeSignatureNoteValue: self.metronomeEnvironment.measure.timeSignature.noteValue, compound: self.metronomeEnvironment.measure.compound, geometry: geometry.size)
            }
            
            Spacer()
        }.frame(height: rhythmDisplayMaxHeight)
        .padding(.vertical)
    }
}


struct NoteValueList: View {
    @EnvironmentObject var metronomeEnvironment: MetronomeEnvironment
    
    let geometryWidth: CGFloat

    var body: some View {
        HStack(alignment: metronomeEnvironment.rhythmEditorObject.rest ? .center : .bottom, spacing: 0) {
            
            ForEach(NoteValueFraction.allCases.dropLast(), id: \.rawValue) { noteValue in
                return Group{
                    if((self.metronomeEnvironment.measure.compound ? noteValue.rawValue*2 : noteValue.rawValue)  >= self.metronomeEnvironment.measure.timeSignature.noteValue.rawValue){
                        
                        if(!self.metronomeEnvironment.rhythmEditorObject.rest){
                            NoteValue.noteValueView(relativeHeight: 70, fractionOfBeat: 1, timeSignatureNoteValue: noteValue)
                        }else{
                            NoteValue.restView(relativeHeight: 70, fractionOfBeat: 1, timeSignatureNoteValue: noteValue)
                        }
                    }
                }.opacity(self.metronomeEnvironment.rhythmEditorObject.noteValueFits(noteValue: noteValue, timeSignatureNoteValue: self.metronomeEnvironment.measure.timeSignature.noteValue) ? 1 : 0.5)
                .onTapGesture {
                    if(self.metronomeEnvironment.rhythmEditorObject.noteValueFits(noteValue: noteValue, timeSignatureNoteValue: self.metronomeEnvironment.measure.timeSignature.noteValue)){
                        self.metronomeEnvironment.rhythmEditorObject.addNoteValue(noteValueFraction: noteValue, timeSignatureNoteValue: self.metronomeEnvironment.measure.timeSignature.noteValue)
                    }
                }
                .frame(width: self.geometryWidth/CGFloat(NoteValueFraction.allCases.dropLast().count) - 2)
            }
        }
    }
}

struct RestToggle: View {
    @EnvironmentObject var metronomeEnvironment: MetronomeEnvironment

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(lineWidth: 3)
            .foregroundColor(.blue)
            .opacity(metronomeEnvironment.rhythmEditorObject.rest ? 1 : 0)
            .overlay(QuarterRest(relativeHeight: 70))
            .frame(width: 70, height: 70)
            .onTapGesture {
                self.metronomeEnvironment.rhythmEditorObject.rest.toggle()
                self.metronomeEnvironment.rhythmEditorObject.accent = false
            }
    }
}
 

struct AccentToggle: View {
    @EnvironmentObject var metronomeEnvironment: MetronomeEnvironment
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(lineWidth: 3)
            .foregroundColor(.blue)
            .opacity(metronomeEnvironment.rhythmEditorObject.accent ? 1 : 0)
            .overlay(
                Accent(relativeHeight: 70)
                    .opacity(metronomeEnvironment.rhythmEditorObject.rest ? 0.5 : 1)
            )
            .frame(width: 70, height: 70)
            .onTapGesture {
                self.metronomeEnvironment.rhythmEditorObject.accent.toggle()
            }
            .disabled(metronomeEnvironment.rhythmEditorObject.rest)
    }
}


struct DotToggle: View {
    @EnvironmentObject var metronomeEnvironment: MetronomeEnvironment
    
    @State var showDotNumSelec: Bool = false

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(lineWidth: 3)
            .foregroundColor(.blue)
            .opacity(metronomeEnvironment.rhythmEditorObject.dot ? 1 : 0)
            .overlay(
                
                HStack(spacing: 3){
                    ForEach(1...metronomeEnvironment.rhythmEditorObject.dotNum, id: \.self){ _ in
                        Dot(relativeHeight: 70)
                    }
                }
                
            )
            .overlay(
                AnyView(
                    Group{
                        
                        if(showDotNumSelec){
                            DotNumSelec(showDotNumSelec: $showDotNumSelec)
                        }
                        
                    }
                ).offset(y: 60)
            )
            .frame(width: 70, height: 70)
            .onTapGesture {
                self.metronomeEnvironment.rhythmEditorObject.dot.toggle()
            }
            .onLongPressGesture {
                self.showDotNumSelec.toggle()
            }
    }
    
    
}

struct DotNumSelec: View {
    @EnvironmentObject var metronomeEnvironment: MetronomeEnvironment
    @Binding var showDotNumSelec: Bool
    
    let maxDots = 3
    
    var body: some View {
        HStack {
            ForEach(1...maxDots, id: \.self){ dotNum in
                HStack(spacing: 3){
                    ForEach(1...dotNum, id: \.self){ _ in
                        Dot(relativeHeight: 70)
                    }
                }.frame(width: 40)
                .onTapGesture {
                    self.metronomeEnvironment.rhythmEditorObject.dotNum = dotNum
                    self.showDotNumSelec = false
                }
            }
        }
    }
}

struct RhythmEditorView_Previews: PreviewProvider {
    static var previews: some View {
        RhythmEditorView(showRhythmEditor: .constant(true), showRhythmPicker: .constant(false))
    }
}
