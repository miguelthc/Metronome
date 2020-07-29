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
    
    let timeSignatureNoteValue: NoteValueFraction
    
    init(timeSignatureNoteValue: NoteValueFraction){
        self.timeSignatureNoteValue = timeSignatureNoteValue
    }
    
    func clearRhythm(){
        print(rhythm.noteValues.count)
        rhythm.noteValues = []
    }
    
    func rhythmComplete() -> Bool{
        return currentlyOccupied() == 1
    }
    
    private func currentlyOccupied() -> Double{
        var occupied = 0.0
        
        for noteValue in rhythm.noteValues {
            occupied += noteValue.fractionOfBeat // If fraction is too high precision is lost
        }
        
        return occupied
    }
    
    func noteValueFits(noteValue: NoteValueFraction) -> Bool {
        var occupied = currentlyOccupied()
        
        let fractionOfBeat = noteValue.rawValue/timeSignatureNoteValue.rawValue
        
        occupied += 1.0/Double(fractionOfBeat)
        
        if(dot){
            occupied += NoteValue.dotSum(baseFraction: fractionOfBeat, dots: dotNum)
        }
        
        return occupied <= 1 && (!dot || noteValue.rawValue < NoteValueFraction.SIXTY_FOURTH.rawValue)
    }
    
    func addNoteValue(noteValueFraction: NoteValueFraction) {
        let fractionOfBeat = noteValueFraction.rawValue/timeSignatureNoteValue.rawValue
        
        let noteValue = NoteValue(baseFraction: fractionOfBeat, isRest: rest, accent: accent , dots: dot ? dotNum : 0)
        
        rhythm.noteValues.append(noteValue)
    }
}

struct RhythmEditorView: View {
    @EnvironmentObject var metronomeEnvironment: MetronomeEnvironment
    @EnvironmentObject var metronomeRepository: MetronomeRepository
    @EnvironmentObject var rhythmEditorObject: RhythmEditorObject
    
    @Binding var showBeatEditor: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack {

                HStack {
                    Spacer()
                    
                    Button(action: self.rhythmEditorObject.clearRhythm){
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
                    self.showBeatEditor = false
                }){
                    Image(systemName: "plus")
                        .font(.system(size: 30))
                        .frame(width: 60, height: 60)
                }.disabled(!self.rhythmEditorObject.rhythmComplete())
            }
        }
    }
    
    func addRhythm(){
        metronomeRepository.addRhythm(rhythm: rhythmEditorObject.rhythm)
        metronomeEnvironment.selectRhythm(rhythm: rhythmEditorObject.rhythm)
    }
}

struct RhythmDisplay: View {
    @EnvironmentObject var metronomeEnvironment: MetronomeEnvironment
    @EnvironmentObject var rhythmEditorObject: RhythmEditorObject
    
    var body: some View {
        HStack {

            Spacer()

            if(!rhythmEditorObject.rhythm.noteValues.isEmpty){
                RhythmView(rhythm: rhythmEditorObject.rhythm, timeSignatureNoteValue: metronomeEnvironment.measure.timeSignatureNoteValue)
            }else{
                RhythmView(rhythm: Rhythm(), timeSignatureNoteValue: .QUARTER)
                    .opacity(0)
            }

            Spacer()
        }.frame(height: RhythmView.relativeHeight)
        .padding(.vertical)
    }
}


struct NoteValueList: View {
    @EnvironmentObject var metronomeEnvironment: MetronomeEnvironment
    @EnvironmentObject var rhythmEditorObject: RhythmEditorObject
    
    let geometryWidth: CGFloat

    var body: some View {
        HStack(alignment: rhythmEditorObject.rest ? .center : .bottom, spacing: 0) {
            
            ForEach(NoteValueFraction.allCases.dropLast(), id: \.rawValue) { noteValue in
                return Group{
                    if(noteValue.rawValue >= self.metronomeEnvironment.measure.timeSignatureNoteValue.rawValue){
                        
                        if(!self.rhythmEditorObject.rest){
                            NoteValue.noteValueView(relativeHeight: 70, fractionOfBeat: 1, timeSignatureNoteValue: noteValue)
                        }else{
                            NoteValue.restView(relativeHeight: 70, fractionOfBeat: 1, timeSignatureNoteValue: noteValue)
                        }
                    }
                }.opacity(self.rhythmEditorObject.noteValueFits(noteValue: noteValue) ? 1 : 0.5)
                .onTapGesture {
                    if(self.rhythmEditorObject.noteValueFits(noteValue: noteValue)){
                        self.rhythmEditorObject.addNoteValue(noteValueFraction: noteValue)
                    }
                }
                .frame(width: self.geometryWidth/CGFloat(NoteValueFraction.allCases.dropLast().count) - 2)
            }
        }
    }
}

struct RestToggle: View {
    @EnvironmentObject var rhythmEditorObject: RhythmEditorObject

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(lineWidth: 3)
            .foregroundColor(.blue)
            .opacity(rhythmEditorObject.rest ? 1 : 0)
            .overlay(QuarterRest(relativeHeight: 70))
            .frame(width: 70, height: 70)
            .onTapGesture {
                self.rhythmEditorObject.rest.toggle()
                self.rhythmEditorObject.accent = false
            }
    }
}
 

struct AccentToggle: View {
    @EnvironmentObject var rhythmEditorObject: RhythmEditorObject
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(lineWidth: 3)
            .foregroundColor(.blue)
            .opacity(rhythmEditorObject.accent ? 1 : 0)
            .overlay(
                Accent(relativeHeight: 70)
                    .opacity(rhythmEditorObject.rest ? 0.5 : 1)
            )
            .frame(width: 70, height: 70)
            .onTapGesture {
                self.rhythmEditorObject.accent.toggle()
            }
            .disabled(rhythmEditorObject.rest)
    }
}


struct DotToggle: View {
    @EnvironmentObject var rhythmEditorObject: RhythmEditorObject
    
    @State var showDotNumSelec: Bool = false

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(lineWidth: 3)
            .foregroundColor(.blue)
            .opacity(rhythmEditorObject.dot ? 1 : 0)
            .overlay(
                
                HStack(spacing: 3){
                    ForEach(1...rhythmEditorObject.dotNum, id: \.self){ _ in
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
                self.rhythmEditorObject.dot.toggle()
            }
            .onLongPressGesture {
                self.showDotNumSelec.toggle()
            }
    }
    
    
}

struct DotNumSelec: View {
    @EnvironmentObject var rhythmEditorObject: RhythmEditorObject
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
                    self.rhythmEditorObject.dotNum = dotNum
                    self.showDotNumSelec = false
                }
            }
        }
    }
}

struct RhythmEditorView_Previews: PreviewProvider {
    static var previews: some View {
        RhythmEditorView(showBeatEditor: .constant(true))
    }
}
