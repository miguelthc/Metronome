//
//  OneHundredTwentyEighthRest.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 16/05/2020.
//  Copyright © 2020 Miguel Carvalho. All rights reserved.
//

import SwiftUI

struct OneHundredTwentyEighthRest: MusicalComponent, View {
    let width: CGFloat?
    let height: CGFloat?
    
    init(relativeWidth: CGFloat){
        width = relativeWidth * (661/600)
        height = nil
    }
    
    init(relativeHeight: CGFloat){
        width = relativeHeight / 3.14 * (661/600)
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
        Image("OneHundredTwentyEighthRest")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: height)
    }
}

struct OneHundredTwentyEighthRest_Previews: PreviewProvider {
    static var previews: some View {
        OneHundredTwentyEighthRest(relativeHeight: 100)
    }
}
