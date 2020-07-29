//
//  QuarterNote.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 08/05/2020.
//  Copyright © 2020 Miguel Carvalho. All rights reserved.
//

import SwiftUI

struct QuarterNote: MusicalComponent, View {
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
        ZStack(){
            GeometryReader { geometry in
                Group{
                    Image("NoteHeadFilled")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width/*, height: geometry.size.height/3.8150*/)
                }.frame(height: geometry.size.height, alignment: .bottomTrailing)
                    
                Group{
                    Image("StandardStem")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width/10)
                }.frame(width: geometry.size.width, alignment: .trailing)
            }
        }.frame(width: width, height: height)
    }
}

struct QuarterNote_Previews: PreviewProvider {
    static var previews: some View {
        QuarterNote(relativeHeight: 500)
    }
}
