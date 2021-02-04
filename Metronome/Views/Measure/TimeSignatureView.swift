//
//  TimeSignatureView.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 11/07/2020.
//

import SwiftUI

struct TimeSignatureView: View {
    @EnvironmentObject var metronomeEnvironment: MetronomeEnvironment
    @Environment(\.colorScheme) var colorScheme
    @State var showIncrementers: Bool = false
    
    var body: some View {
        ZStack {
            Button(action: {showIncrementers.toggle()} ){
                VStack (spacing: 0.5){
                    Text("\(metronomeEnvironment.measure.timeSignature.noteCount)")
                    
                    Text("\(metronomeEnvironment.measure.timeSignature.noteValue.rawValue)")
                }.modifier(TimeSignatureStyle(dark: colorScheme == .dark))
            }
            
            if showIncrementers {
                Incrementer(increment: metronomeEnvironment.incrementBeatsPerMeasure,
                            decrement: metronomeEnvironment.decrementBeatsPerMeasure,
                            decrementDisabled: metronomeEnvironment.measure.beatsPerMeasure == Measure.minBeatsPerMeasure,
                            incrementDisabled: metronomeEnvironment.measure.beatsPerMeasure == Measure.maxBeatsPerMeasure)
                    .offset(y: -55)
                
                Incrementer(increment: metronomeEnvironment.incrementMeasureNoteValue,
                            decrement: metronomeEnvironment.decrementMeasureNoteValue,
                            decrementDisabled: metronomeEnvironment.measure.timeSignature.noteValue == (metronomeEnvironment.measure.compound ? NoteValueFraction.HALF : NoteValueFraction.WHOLE),
                            incrementDisabled: metronomeEnvironment.measure.timeSignature.noteValue == NoteValueFraction.SIXTY_FOURTH)
                    .offset(y: 55)
            }
        }
    }
}

struct Incrementer: View {
    @Environment(\.colorScheme) var colorScheme
    
    let increment: () -> ()
    let decrement: () -> ()
    let decrementDisabled: Bool
    let incrementDisabled: Bool
    
    var body: some View {
        ZStack{
            HStack (spacing: 0) {
                
                
                Button(action: { self.decrement() }){
                    Image(systemName: "minus")
                }.frame(width: 30, height: 30)
                .disabled(decrementDisabled)
                
                Divider()
                
                Button(action: { self.increment() }){
                    Image(systemName: "plus")
                }.frame(width: 30, height: 30)
                .disabled(incrementDisabled)
                
            }
        }.modifier(IncrementerStyle(dark: colorScheme == .dark))
        
        
    }
}

struct TimeSignatureStyle: ViewModifier {
    let dark: Bool
    
    func body(content: Content) -> some View {
        content
            .frame(width: 60, height: 60)
            .foregroundColor(dark ? Color.white : Color.black)
            .font(.custom("", size: 22))
            .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(Color(red: 50/255, green: 50/255, blue: 50/255), lineWidth: 1)
                .shadow(color: Color.black, radius: 0.5))
            .padding(.horizontal, 25)
    }
}

struct IncrementerStyle: ViewModifier {
    let dark: Bool
    
    func body(content: Content) -> some View {
        content
            .frame(width: 60, height: 30)
            .background(dark ? Color(red: 50/255, green: 50/255, blue: 54/255) : Color(red: 230/255, green: 230/255, blue: 234/255))
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .shadow(color: Color(red: 150/255, green: 150/255, blue: 150/255), radius: 1)
    }
}

struct TimeSignatureView_Previews: PreviewProvider {
    static var previews: some View {
        TimeSignatureView()
    }
}
