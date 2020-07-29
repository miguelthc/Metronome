//
//  KnobView.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 11/07/2020.
//

import SwiftUI

struct KnobView: View {
    @EnvironmentObject var metronomeEnvironment: MetronomeEnvironment
    @State var knobState = KnobState()
    
    var body: some View {
        ZStack(alignment: .top) {
            if(metronomeEnvironment.beatOccured){
                Circle()
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundColor(.green)
                    .onAppear(perform: metronomeEnvironment.beatOccuredDisplayed)
            }
            
            GeometryReader { geometry in
                Circle().stroke(lineWidth: 3).aspectRatio(1, contentMode: .fit)
                    .padding(5)
                    .gesture(DragGesture()
                        .onChanged { value in
                            self.knobRotation(geometry: geometry, location: value.location, startLocation: value.startLocation)
                        }
                        .onEnded {_ in
                            self.gestureEnded()
                        }
                    )
            }
            
            ZStack (alignment: .top){
                Circle().frame(width: 10, height: 10)
                Circle()
                .aspectRatio(1, contentMode: .fit)
                .padding(5)
                .opacity(0)
            }.rotationEffect(Angle(radians: knobState.rotationAngle(bpm: metronomeEnvironment.bpm)))
        }
    }
    
    struct KnobState {
        var gestureOngoing = false
        var lastXPositive = false
        var angleOffset = 0.0
        var initialAngle = 0.0
        var initialBpm = 0.0
        
        func rotationAngle(bpm: Double) -> Double {
            return bpm * 2 * Double.pi / 60
        }
    }
    
    func knobRotation(geometry: GeometryProxy, location: CGPoint, startLocation: CGPoint) {
        let offsetX = geometry.size.width/2
        let offsetY = geometry.size.height/2
        let startX = startLocation.x - offsetX
        let startY = offsetY - startLocation.y
        let x = location.x - offsetX
        let y = -(location.y - offsetY)
        
        if(!knobState.gestureOngoing){
            knobState.initialBpm = metronomeEnvironment.bpm
            knobState.angleOffset = 0
            knobState.initialAngle = Double(atan(startY/startX))
        }
        
        let gestureAngle = Double(atan(y/x))
        
        if (x > 0) {
            if(knobState.gestureOngoing && !knobState.lastXPositive || !knobState.gestureOngoing && startX < 0){
                if(y > 0){
                    knobState.angleOffset += Double.pi
                }else{
                    knobState.angleOffset -= Double.pi
                }
            }
            knobState.lastXPositive = true
        }else{
            if(knobState.gestureOngoing && knobState.lastXPositive || !knobState.gestureOngoing && startX > 0){
                if(y > 0){
                    knobState.angleOffset -= Double.pi
                }else{
                    knobState.angleOffset += Double.pi
                }
            }
            knobState.lastXPositive = false
        }
        
        let bpmAfterRotation = knobState.initialBpm + angleToBpm(angle: knobState.initialAngle - gestureAngle + knobState.angleOffset)
        
        if(bpmAfterRotation > Metronome.maxBpm) {
            metronomeEnvironment.bpm = Metronome.maxBpm
            knobState.initialAngle = gestureAngle
            knobState.initialBpm = metronomeEnvironment.bpm
            knobState.angleOffset = 0

        } else if (bpmAfterRotation < Metronome.minBpm) {
            metronomeEnvironment.bpm = Metronome.minBpm
            knobState.initialAngle = gestureAngle
            knobState.initialBpm = metronomeEnvironment.bpm
            knobState.angleOffset = 0
        } else {
            metronomeEnvironment.bpm = bpmAfterRotation
        }
        
        knobState.gestureOngoing = true
    }
    
    func gestureEnded(){
        knobState.gestureOngoing = false
        knobState.angleOffset = 0.0
        
    }
    
    private func angleToBpm(angle: Double) -> Double{
        return 60 * angle/(2*Double.pi)
    }
}

struct KnobView_Previews: PreviewProvider {
    static var previews: some View {
        KnobView()
    }
}
