//
//  MetronomeListItem.swift
//  Metronome
//
//  Created by Miguel Carvalho on 28/09/2020.
//  Copyright © 2020 Miguel Carvalho. All rights reserved.
//

import SwiftUI

struct MetronomeListItem: View {
    let metronome: Metronome
    
    var body: some View {
        HStack {
            Text(metronome.name).lineLimit(1)
            Text(String(format: "%.0f", metronome.bpm))
        }
    }
}

struct MetronomeListItem_Previews: PreviewProvider {
    static var previews: some View {
        MetronomeListItem(metronome: Metronome())
    }
}
