//
//  HalfNote.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 13/05/2020.
//  Copyright © 2020 Miguel Carvalho. All rights reserved.
//

import SwiftUI

struct HalfNote: MusicalComponent, View {
    let width: CGFloat?
    let height: CGFloat?
    
    init(relativeWidth: CGFloat){
        width = relativeWidth
        height = relativeWidth * 3.14
    }
    
    init(relativeHeight: CGFloat){
        width = relativeHeight / 3.14
        height = relativeHeight
    }
    
    init(absoluteWidth: CGFloat){
        width = absoluteWidth
        height = absoluteWidth * 3.14
    }
    
    init(absoluteHeight: CGFloat){
        width = absoluteHeight / 3.14
        height = absoluteHeight
    }
    
    var body: some View {
        Group{
            GeometryReader { geometry in
                ZStack(alignment: .bottomTrailing){
                    Image("NoteHeadOpen")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width/*, height: geometry.size.height /3.8150*/)
                
                    Image("StandardStem")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width/10/*, height: geometry.size.height/1.2129*/)
                        .offset(y: -geometry.size.height/5.6996)
                }.frame(width: self.width, height: self.height, alignment: .bottom)
            }
        }.frame(width: width, height: height, alignment: .bottom)
    }
}

struct HalfNote_Previews: PreviewProvider {
    static var previews: some View {
        HalfNote(relativeHeight: 100)
    }
}
