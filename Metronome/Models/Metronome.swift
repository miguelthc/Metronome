//
//  Metronome.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 11/07/2020.
//

import Foundation

private let DEFAULT_BPM = 60.0
private let MINIMUM_BPM = 30.0
private let MAXIMUM_BPM = 300.0
private let DEFAULT_NAME = "Metronome"

struct Metronome {
    var name: String = DEFAULT_NAME
    var bpm: Double = DEFAULT_BPM
    var measure: Measure = Measure()
}

extension Metronome {
    static let minBpm: Double = MINIMUM_BPM
    static let maxBpm: Double = MAXIMUM_BPM
    static let defaultName: String = DEFAULT_NAME
}
