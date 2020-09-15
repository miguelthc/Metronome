//
//  ContentView.swift
//  Metronome
//
//  Created by Miguel Carvalho on 27/07/2020.
//  Copyright © 2020 Miguel Carvalho. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MetronomeView()
            .background(Color.init(red: 251/255, green: 254/255, blue: 254/255).edgesIgnoringSafeArea(.all))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
