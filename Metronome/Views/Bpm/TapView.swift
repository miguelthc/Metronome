//
//  TapView.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 11/07/2020.
//

import SwiftUI

struct TapView: View {
    @EnvironmentObject var metronomeEnvironment: MetronomeEnvironment

    var body: some View {
        Group{
            Button(action: metronomeEnvironment.tap ) {
                Image(systemName: "hand.point.right")
                .resizable()
                    .rotationEffect(Angle(degrees: -90))
                    .aspectRatio(contentMode: .fit)
            }.padding()
        }.modifier(PlayStyle())
    }
}

struct TapView_Previews: PreviewProvider {
    static var previews: some View {
        TapView()
    }
}
