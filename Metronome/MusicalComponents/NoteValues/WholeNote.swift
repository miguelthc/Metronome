//
//  WholeNote.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 13/05/2020.
//  Copyright © 2020 Miguel Carvalho. All rights reserved.
//

import SwiftUI

struct WholeNote: MusicalComponent, View {
    let width: CGFloat?
    let height: CGFloat?
    let frameHeight: CGFloat
    
    init(relativeWidth: CGFloat){
        width = nil
        height = 0.823 * relativeWidth // 7 * √(93) * relativeWidth / (31 * √(7))
        self.frameHeight = relativeWidth * 3.14
    }
    
    init(relativeHeight: CGFloat){
        width = nil
        height = 0.2621 * relativeHeight // (relativeHeight / 3.14) * 7 * √(93) * relativeWidth / (31 * √(7))
        self.frameHeight = relativeHeight
    }
    
    init(absoluteWidth: CGFloat){
        width = absoluteWidth
        height = nil
        // WRONG v
        self.frameHeight = absoluteWidth * 3.14
    }
    
    init(absoluteHeight: CGFloat){
        width = nil
        height = absoluteHeight
        self.frameHeight = absoluteHeight
    }
    
    var body: some View {
        VStack{
            Spacer()
            
            Image("WholeNote")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
        }.frame(height: frameHeight)
    }
}

struct WholeNote_Previews: PreviewProvider {
    static var previews: some View {
        WholeNote(relativeHeight: 100)
    }
}
