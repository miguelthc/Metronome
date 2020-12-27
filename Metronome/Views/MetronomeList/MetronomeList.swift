//
//  MetronomeList.swift
//  Metronome
//
//  Created by Miguel Carvalho on 28/09/2020.
//  Copyright © 2020 Miguel Carvalho. All rights reserved.
//

import SwiftUI

struct MetronomeList: View {
    @EnvironmentObject var metronomeRepository: MetronomeRepository
    @EnvironmentObject var metronomeEnvironment: MetronomeEnvironment
    
    @Binding var showMetronomeList: Bool
    
    var body: some View {
        List {
            ForEach(metronomeRepository.loadMetronomes(), id: \.name) { metronome in
                MetronomeListItem(metronome: metronome)
                    .onTapGesture {
                        metronomeEnvironment.setNewMetronome(metronome: metronome)
                        showMetronomeList = false
                    }
            }
        }.toolbar {
            ToolbarItem(){
                Button(action: {
                    metronomeEnvironment.setNewMetronome(metronome: Metronome(name: metronomeRepository.defaultMetronomeName()))
                    showMetronomeList = false
                }) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct MetronomeList_Previews: PreviewProvider {
    static var previews: some View {
        MetronomeList(showMetronomeList: .constant(true))
    }
}
