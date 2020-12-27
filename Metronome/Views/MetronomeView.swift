//
//  ContentView.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 11/07/2020.
//

import SwiftUI

struct MetronomeView: View {
    @EnvironmentObject var metronomeEnvironment: MetronomeEnvironment
    @EnvironmentObject var metronomeRepository: MetronomeRepository
    
    @State private var showMetronomeList: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(
                    destination:  MetronomeList(showMetronomeList: $showMetronomeList)
                                        .environmentObject(metronomeRepository),
                    isActive: $showMetronomeList,
                    label: {EmptyView()}
                )
                
                Spacer()
                
                MeasureView()
                
                Spacer()
                Spacer()
                
                BpmView(bpm: metronomeEnvironment.bpm)
                
                Spacer()
                
                HStack {
                    TimeSignatureView()
                    
                    Spacer()
                    
                    BeatValueView()
                        .onTapGesture {
                        self.metronomeEnvironment.toggleCompoundMeasure()
                        }
                        .disabled(!metronomeEnvironment.measure.noteCountIsMultipleOf3)
                }
                
                BpmController()
                
                HStack {
                    PlayView()
                    
                    Spacer()
                    
                    TapView()
                }.padding(.bottom, 16)
            }.navigationBarTitle(metronomeEnvironment.metronome.name, displayMode: .inline)
            .toolbar {
                ToolbarItem() {
                    HStack{
                        
                        
                        Button(action: {
                                metronomeRepository.addMetronome(metronome: metronomeEnvironment.metronome)
                                showMetronomeList = true
                        }){
                            Image(systemName: "list.bullet")
                        }
                    }
                }
            }
        }
    }
}

struct MetronomeView_Previews: PreviewProvider {
    static var previews: some View {
        MetronomeView()
    }
}
