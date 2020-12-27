//
//  AppDelegate.swift
//  Metronome
//
//  Created by Miguel Carvalho on 27/07/2020.
//  Copyright © 2020 Miguel Carvalho. All rights reserved.
//

import SwiftUI

@main
struct MetronomeApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    var metronomeRep: MetronomeRepository
    var metronomeEnv: MetronomeEnvironment
    
    init(){
        metronomeRep = MetronomeRepository()
        metronomeEnv = MetronomeEnvironment(metronome: metronomeRep.lastUsedMetronome)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(metronomeRep)
                .environmentObject(metronomeEnv)
        }
        .onChange(of: scenePhase){ phase in
            if phase == .inactive {
                metronomeRep.addMetronome(metronome: metronomeEnv.metronome)
                metronomeRep.lastUsedMetronome = metronomeEnv.metronome
            }
        }
    }
}
