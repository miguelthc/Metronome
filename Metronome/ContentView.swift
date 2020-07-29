//
//  ContentView.swift
//  Metronome
//
//  Created by Miguel Carvalho on 27/07/2020.
//  Copyright © 2020 Miguel Carvalho. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var metronomeEnv = MetronomeEnvironment()
    var metronomeRep = MetronomeRepository()
    
    var body: some View {
        MetronomeView()
        .environmentObject(metronomeEnv)
        .environmentObject(metronomeRep)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
