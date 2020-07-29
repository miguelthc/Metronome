//
//  SixteenthNote.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 14/05/2020.
//  Copyright © 2020 Miguel Carvalho. All rights reserved.
//

import SwiftUI

struct SixteenthNote: MusicalComponent, View {
    let width: CGFloat?
    let height: CGFloat?
    
    init(relativeWidth: CGFloat){
        width = relativeWidth * 1.625
        height = relativeWidth * 3.14
    }
    
    init(relativeHeight: CGFloat){
        width = relativeHeight / 3.14 * 1.625
        height = relativeHeight
    }
    
    init(absoluteWidth: CGFloat){
        width = absoluteWidth
        height = absoluteWidth / 1.625 * 3.14
    }
    
    init(absoluteHeight: CGFloat){
        width = absoluteHeight / 3.14 * 1.625
        height = absoluteHeight
    }
    
    var body: some View {
        GeometryReader{ geometry in
            HStack(alignment: .top, spacing: 0){
                QuarterNote(absoluteHeight: self.height!)
                
                Image("SixteenthFlag")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: geometry.size.height - geometry.size.height/3.8150/2) // height - half_head_size
            }/*.aspectRatio((1+1/1.6)/3.14, contentMode: .fit)  // needed?*/
        }.frame(width: width, height: height)
    }
}

struct SixteenthNote_Previews: PreviewProvider {
    static var previews: some View {
        SixteenthNote(relativeHeight: 100)
    }
}
