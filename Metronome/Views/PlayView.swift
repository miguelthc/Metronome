//
//  PlayTapView.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 11/07/2020.
//

import SwiftUI

struct PlayView: View {
    @EnvironmentObject var metronomeEnvironment: MetronomeEnvironment

    var body: some View {
        Group{
            Button(action: metronomeEnvironment.changeMetronomePlayingState ) {
                Image(systemName: !metronomeEnvironment.isPlaying ? "play" : "pause")
                .resizable()
                .aspectRatio(contentMode: .fit)
                    //TODO: Calculate triangle center
            }.padding()
        }.modifier(PlayStyle())
    }
}

struct PlayStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 60, height: 60)
            .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(Color(red: 50/255, green: 50/255, blue: 50/255), lineWidth: 0.8)
                .shadow(color: Color.black, radius: 0.5))
            .padding(.horizontal, 25)
    }
}

struct PlayTapView_Previews: PreviewProvider {
    static var previews: some View {
        PlayView()
    }
}
