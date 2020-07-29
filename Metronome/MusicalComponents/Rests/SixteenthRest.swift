//
//  SixteenthRest.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 16/05/2020.
//  Copyright © 2020 Miguel Carvalho. All rights reserved.
//

import SwiftUI

struct SixteenthRest: MusicalComponent, View {
    let width: CGFloat?
    let height: CGFloat?
    
    init(relativeWidth: CGFloat){
        width = relativeWidth * (522/600)
        height = nil
    }
    
    init(relativeHeight: CGFloat){
        width = relativeHeight / 3.14 * (522/600)
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
        Image("SixteenthRest")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: height)
    }
}

struct SixteenthRest_Previews: PreviewProvider {
    static var previews: some View {
        SixteenthRest(relativeHeight: 100)
    }
}
