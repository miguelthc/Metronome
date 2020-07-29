//
//  NoteValueFraction.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 12/07/2020.
//

import Foundation

enum NoteValueFraction: Int, CaseIterable {
    case WHOLE = 1
    case HALF = 2
    case QUARTER = 4
    case EIGHTH = 8
    case SIXTEENTH = 16
    case THIRTY_SECOND = 32
    case SIXTY_FOURTH = 64
    case ONE_HUNDRED_TWENTY_EIGHTH = 128
}

extension NoteValueFraction {
    static let MAX_FRACTION = ONE_HUNDRED_TWENTY_EIGHTH
}
