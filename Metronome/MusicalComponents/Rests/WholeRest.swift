//
//  WholeRest.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 15/05/2020.
//  Copyright © 2020 Miguel Carvalho. All rights reserved.
//

import SwiftUI

struct WholeRest: MusicalComponent, View {
    let width: CGFloat?
    let height: CGFloat?
    
    init(relativeWidth: CGFloat){
        width = relativeWidth * 2
        height = nil
    }
    
    init(relativeHeight: CGFloat){
        width = relativeHeight / 3.14 * 2
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
        Image("WholeRest")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: height)
    }
}

extension WholeRest {
    
}

struct WholeRest_Previews: PreviewProvider {
    static var previews: some View {
        WholeRest(relativeHeight: 100)
    }
}
