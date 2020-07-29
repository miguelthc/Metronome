//
//  BeatValueView.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 11/07/2020.
//

import SwiftUI

struct BeatValueView: View {
    @EnvironmentObject var metronomeEnvironment: MetronomeEnvironment
    
    var body: some View {
        VStack (spacing: 0.5){
            Text("\(metronomeEnvironment.metronome.measure.beatsPerMeasure)")
            
            Text("\(metronomeEnvironment.metronome.measure.timeSignatureNoteValue.rawValue)")
            
        }.onTapGesture {
            
        }
        .modifier(BeatValueStyle())
    }
}

struct BeatValueStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 60, height: 60)
            .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(Color(red: 50/255, green: 50/255, blue: 50/255), lineWidth: 0.8)
                .shadow(color: Color.black, radius: 0.5))
            .padding(.horizontal, 25)
    }
}

struct BeatValueView_Previews: PreviewProvider {
    static var previews: some View {
        BeatValueView()
    }
}
