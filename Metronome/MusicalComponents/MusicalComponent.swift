//
//  Component.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 17/05/2020.
//  Copyright © 2020 Miguel Carvalho. All rights reserved.
//

import Foundation
import SwiftUI

protocol MusicalComponent {
    var width: CGFloat? {get}
    var height: CGFloat? {get}
    
    init(relativeWidth: CGFloat)
    init(relativeHeight: CGFloat)
    init(absoluteWidth: CGFloat)
    init(absoluteHeight: CGFloat)
}
