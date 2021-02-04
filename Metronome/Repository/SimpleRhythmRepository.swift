//
//  SimpleRhythmRepository.swift
//  Metronome
//
//  Created by Miguel Carvalho on 19/01/2021.
//  Copyright © 2021 Miguel Carvalho. All rights reserved.
//

import Foundation

class SimpleRhythmRepository: ObservableObject {
    @Published var simpleRhythms: [Rhythm]
    
    private let dao = RhythmDao()
}
