//
//  MeasureView.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 11/07/2020.
//

import SwiftUI

struct MeasureView: View {
    var body: some View {
        VStack{
            MeasureActionButtonsView()
            
            BeatListContainerView()
        }
    }
}

struct MeasureView_Previews: PreviewProvider {
    static var previews: some View {
        MeasureView()
    }
}
