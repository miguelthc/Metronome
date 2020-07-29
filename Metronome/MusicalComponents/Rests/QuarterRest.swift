//
//  QuarterRest.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 16/05/2020.
//  Copyright © 2020 Miguel Carvalho. All rights reserved.
//

import SwiftUI

struct QuarterRest: MusicalComponent, View {
    let width: CGFloat?
    let height: CGFloat?
    
    init(relativeWidth: CGFloat){
        width = relativeWidth * (3/4)
        height = nil
    }
    
    init(relativeHeight: CGFloat){
        width = relativeHeight / 3.14 * (3/4)
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
        Image("QuarterRest")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: height)
    }
}

struct QuarterRest_Previews: PreviewProvider {
    static var previews: some View {
        QuarterRest(relativeHeight: 800)
    }
}
