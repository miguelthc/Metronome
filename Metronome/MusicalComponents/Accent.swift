//
//  Accent.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 27/07/2020.
//

import SwiftUI

struct Accent: MusicalComponent, View {
    let width: CGFloat?
    let height: CGFloat?
    
    init(relativeWidth: CGFloat){
        width = relativeWidth
        height = nil
    }
    
    init(relativeHeight: CGFloat){
        width = relativeHeight / 3.14
        height = nil
    }
    
    init(absoluteWidth: CGFloat){
        width = absoluteWidth
        height = nil
    }
    
    init(absoluteHeight: CGFloat){
        width = nil
        height = absoluteHeight
    }
    
    var body: some View {
        Image("Accent")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: height)
    }
}

struct Accent_Previews: PreviewProvider {
    static var previews: some View {
        Accent(relativeHeight: 100)
    }
}
