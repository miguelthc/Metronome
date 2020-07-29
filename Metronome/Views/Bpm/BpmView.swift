//
//  BpmView.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 11/07/2020.
//

import SwiftUI

struct BpmView: View {
    let bpm: Double
    
    var body: some View {
        Text(String(format: "%.0f", bpm))
            .modifier(BpmStyle())
    }
}

struct BpmStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            //.frame(width: 180, height: 180, alignment: .center)
            //.multilineTextAlignment(.center)
            .font(.custom("", size: 56))
    
    }
}

struct BpmView_Previews: PreviewProvider {
    static var previews: some View {
        BpmView(bpm: 60)
    }
}
