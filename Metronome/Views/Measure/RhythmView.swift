//
//  RhythmView.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 18/07/2020.
//

import SwiftUI

let FLAGGED_Q: Float = 14.49
let NOTE_VALUE_Q: Float = 8.9
let DOT_Q: Float = 2.97

let FLAG_DOT_SPACING_Q: Float = 1.4
let NOTE_VALUE_DOT_SPACING_Q: Float = 2.97
let DOT_SPACING_Q: Float = 1.75

let SPACING_Q: Float = 5.6

struct RhythmView: View {
    let rhythm: Rhythm
    let timeSignatureNoteValue: NoteValueFraction
    var rhythmComponents: [RhythmComponent] = []
    
    var widthSum: Float = 0
    var relativeHeight: CGFloat = 0
    
    init(rhythm: Rhythm, timeSignatureNoteValue: NoteValueFraction, compound: Bool = false, geometry: CGSize, maxHeight: CGFloat? = nil){
        self.rhythm = rhythm
        self.timeSignatureNoteValue = !compound ? timeSignatureNoteValue : NoteValueFraction.allCases[NoteValueFraction.allCases.firstIndex(of: timeSignatureNoteValue)! - 1]
        
        self.rhythmComponents = rhythmToComponents()
        
        for rhythmComponent in rhythmComponents {
            if rhythmComponent is Isolated {
                if((rhythmComponent as! Isolated).noteValue.isRest){
                    switch((rhythmComponent as! Isolated).noteValue.baseFraction * timeSignatureNoteValue.rawValue){
                        case NoteValueFraction.WHOLE.rawValue,
                             NoteValueFraction.HALF.rawValue:
                            widthSum += 17.8
                        case NoteValueFraction.QUARTER.rawValue:
                            widthSum += 6.675
                        case NoteValueFraction.EIGHTH.rawValue:
                            widthSum += 6.02
                        case NoteValueFraction.SIXTEENTH.rawValue:
                            widthSum += 7.74
                        case NoteValueFraction.THIRTY_SECOND.rawValue:
                            widthSum += 8.9
                        case NoteValueFraction.SIXTY_FOURTH.rawValue:
                            widthSum += 9.67
                        case NoteValueFraction.ONE_HUNDRED_TWENTY_EIGHTH.rawValue:
                            widthSum += 9.8
                        default:
                            break
                    }
                    
                    if((rhythmComponent as! Isolated).noteValue.isDotted()){
                        widthSum += NOTE_VALUE_DOT_SPACING_Q
                    }
                }else{
                    if (rhythmComponent as! Isolated).noteValue.isFlagged(timeSignatureNoteValue: timeSignatureNoteValue) {
                        widthSum += FLAGGED_Q
                        
                        if((rhythmComponent as! Isolated).noteValue.isDotted()){
                            widthSum += FLAG_DOT_SPACING_Q
                        }
                    }else{
                        widthSum += NOTE_VALUE_Q
                        
                        if((rhythmComponent as! Isolated).noteValue.isDotted()){
                            widthSum += NOTE_VALUE_DOT_SPACING_Q
                        }
                    }
                }
                
                widthSum += Float((rhythmComponent as! Isolated).noteValue.dots) * (DOT_Q + DOT_SPACING_Q) - DOT_SPACING_Q
            }else{
                for dots in (rhythmComponent as! Beamed).dots {
                    widthSum += NOTE_VALUE_Q
                    
                    if(dots > 0){
                        widthSum += NOTE_VALUE_DOT_SPACING_Q
                    }
                    
                    widthSum += Float(dots) * (DOT_Q + DOT_SPACING_Q) - DOT_SPACING_Q
                    widthSum += SPACING_Q
                }
            }
            
            widthSum += SPACING_Q
        }
        
        widthSum -= SPACING_Q
        
        
        relativeHeight = min(maxHeight != nil ? (maxHeight!) : geometry.height, CGFloat(NOTE_VALUE_Q*Float(geometry.width)/widthSum*3.14))
        
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: relativeHeight/5.6){
            ForEach(rhythmToComponents(), id: \.id){ component in
                Group{
                    if component is Beamed {
                        BeamedView(beamed: (component as! Beamed), relativeHeight: self.relativeHeight)
                    } else {
                        self.isolated(isolated: (component as! Isolated))
                    }
                }
            }
        }
    }
}

struct BeamedView: View{
    let beamed: Beamed
    @State var quarterNotePoints: [CGPoint]
    
    let relativeHeight: CGFloat
    
    init(beamed: Beamed, relativeHeight: CGFloat){
        self.beamed = beamed
        _quarterNotePoints = State(initialValue: Array<CGPoint>(repeating: CGPoint(), count: beamed.dots.count))
        self.relativeHeight = relativeHeight
    }
    
    var body: some View {
        ZStack(alignment: .topLeading){
            HStack(alignment: .bottom, spacing: relativeHeight/5.6){
                ForEach(beamed.dots.indices, id: \.self){ index in
                    BeamedQuarterNote(dots: self.beamed.dots[index], accent: self.beamed.accents[index], index: index, relativeHeight: self.relativeHeight)
                }
            }.onPreferenceChange(QuarterNotePreferenceKey.self) { preferences in
                for p in preferences {
                    self.quarterNotePoints[p.viewIdx] = p.point
                }
            }
            .coordinateSpace(name: "BeamedStack")
            
            ForEach(self.beamed.beams.indices, id: \.self){ index in
                ForEach(self.beamed.beams[index], id: \.id){ beam in
                    BeamView(beam: beam, index: index, quarterNotePoints: self.quarterNotePoints, relativeHeight: self.relativeHeight)
                        
                }
            }
        }
    }
}

struct BeamView: View {
    let beam: Beam
    let index: Int
    let quarterNotePoints: [CGPoint]
    let relativeHeight: CGFloat
    
    var body: some View {
        Rectangle()
            .frame(width:
                    beam.length == 0 || beam.length == -1 ? relativeHeight/4 :
                self.quarterNotePoints[beam.startPosition + beam.length].x - self.quarterNotePoints[beam.startPosition].x,
                   height: relativeHeight/15.56)
            .offset(x: beam.length == -1 ? self.quarterNotePoints[beam.startPosition].x - relativeHeight/4 : self.quarterNotePoints[beam.startPosition].x, y: CGFloat(index)*relativeHeight/7)
    }
}

struct BeamedQuarterNote: View {
    let dots: Int
    let accent: Bool
    let index: Int
    let relativeHeight: CGFloat
    
    var body: some View {
        HStack(alignment: .bottom, spacing: relativeHeight/3.14/3){
            ZStack(alignment: .bottom){
                QuarterNote(relativeHeight: relativeHeight)
                    .background(QuarterNotePreferenceViewSetter(idx: index))
                
                if(accent){
                    Accent(relativeHeight: relativeHeight)
                        .offset(y: relativeHeight/3)
                }
            }
            
            if(dots > 0){
                ForEach(1...dots, id: \.self){ _ in
                    NoteValue.addDots(relativeHeight: self.relativeHeight)
                }
            }
        }
    }
}

struct QuarterNotePreferenceViewSetter: View {
    let idx: Int
    
    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.clear)
                .preference(key: QuarterNotePreferenceKey.self,
                            value: [QuarterNotePreferenceData(viewIdx: self.idx, point: CGPoint(x: geometry.frame(in: .named("BeamedStack")).origin.x + geometry.frame(in: .named("BeamedStack")).width, y: geometry.frame(in: .named("BeamedStack")).origin.y))])
        }
    }
}

struct QuarterNotePreferenceKey: PreferenceKey {
    typealias Value = [QuarterNotePreferenceData]

    static var defaultValue: [QuarterNotePreferenceData] = []
    
    static func reduce(value: inout [QuarterNotePreferenceData], nextValue: () -> [QuarterNotePreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}

struct QuarterNotePreferenceData: Equatable {
    let viewIdx: Int
    let point: CGPoint
}
  


extension RhythmView {
    func isolated(isolated: Isolated) -> AnyView {
        return AnyView(
            isolated.noteValue.image(timeSignatureNoteValue: timeSignatureNoteValue, relativeHeight: relativeHeight)
        )
    }
    
    func rhythmToComponents() -> [RhythmComponent] {
        var rhythmComponents: [RhythmComponent] = []
        var i = 0
        
        var sum: Int = 0
        var maxFraction: Int = 0
        
        for fraction in NoteValueFraction.allCases {
            if fraction.rawValue > maxFraction {
                maxFraction = fraction.rawValue
            }
        }
        
        let beamNumOffset: Int = timeSignatureNoteValue.rawValue <= NoteValueFraction.HALF.rawValue ? 1 : 2
        
        
        func isBeamed(noteValue: NoteValue) -> Bool {
            return !noteValue.isRest && noteValue.baseFraction*timeSignatureNoteValue.rawValue >= NoteValueFraction.EIGHTH.rawValue
        }
        
        
        func numberOfBeams(noteValue: NoteValue) -> Int {
            return Int(log2(Double(noteValue.baseFraction*timeSignatureNoteValue.rawValue))) - Int(log2(Double(NoteValueFraction.QUARTER.rawValue)))
        }
        
        
        func gcd(sum: Int) -> Int{
            var numerator = sum
            var gcd = 1
            
            while(numerator % 2 == 0){
                numerator /= 2
                gcd *= 2
            }
            
            return gcd
        }
        
        // NOT BEING USED - ADD TO EVERY NOTE ADDED
        func updateSum(noteValue: NoteValue){
            sum += maxFraction/Int((1.0/noteValue.fractionOfBeat).rounded())
        }
        
        
        func appendIsolated(noteValue: NoteValue){
            rhythmComponents.append(Isolated(noteValue: noteValue))
            //updateSum(noteValue: noteValue)
            i += 1
        }
        
        func noBeamsOnLevel(beamed: Beamed, noteValue: NoteValue, position: Int, maxBeams: Int, level b: Int) -> Beamed{
            let beamed = beamed
            
            if(position == 0 && maxBeams == 0){ // beam properties split beamed and you get isolated on left side
                appendIsolated(noteValue: noteValue)
            }else{
                beamed.beams.insert([], at: b)
                
                if(i > 0 && b+1 > numberOfBeams(noteValue: rhythm.noteValues[i-1]) && (b+1 > maxBeams || i+1 == rhythm.noteValues.count) || i+1 < rhythm.noteValues.count && rhythm.noteValues[i+1].isRest){ //length is negative
                    
                    beamed.beams[b].append(Beam(startPosition: position, length: -1))
                    
                }else{ //length is positive
                    
                    beamed.beams[b].append(Beam(startPosition: position))
                    
                }
            }
            
            return beamed
        }
        
        
        func beamsOnLevel(beamed: Beamed, noteValue: NoteValue, position: Int, maxBeams: Int, level b: Int, beamsInPosition: Int) -> Beamed {
            var beamed = beamed
            
            let lastBeam = beamed.beams[b].last!
            
            if((position - (lastBeam.startPosition + lastBeam.length)) > 1){ // new Beam
                
                if(b+1 > numberOfBeams(noteValue: rhythm.noteValues[i-1]) && (b+1 > maxBeams || i+1 == rhythm.noteValues.count) || i+1 < rhythm.noteValues.count && rhythm.noteValues[i+1].isRest){ //length is negative
                    
                    beamed.beams[b].append(Beam(startPosition: position, length: -1))
                    
                }else{ //length is positive
                    
                    beamed.beams[b].append(Beam(startPosition: position))
                    
                }
                
            }else{ // check beam properties
                
                if(i+1 < rhythm.noteValues.count && beamsInPosition >= maxBeams + beamNumOffset && numberOfBeams(noteValue: rhythm.noteValues[i+1]) >= maxBeams + beamNumOffset){ //split beams
                    
                    beamed.beams[b].append(Beam(startPosition: position))
                    
                    if(maxBeams == 0){
                        rhythmComponents.append(beamed)
                        beamed = Beamed()
                    }
                    
                }else{ // add to last beam
                    
                    beamed.beams[b][beamed.beams[b].count-1].length += 1
                    
                }
            }
            
            return beamed
        }
        
        
        func processNoteValueBeams(beamed: Beamed, noteValue: NoteValue, position: Int, maxBeams: Int) -> Beamed {
            var beamed = beamed
            let beamsInPosition = numberOfBeams(noteValue: noteValue)
            
            for b in 0..<beamsInPosition {
                
                if (beamed.beams.count <= b){ // no beams on "level" b (count <= b works because you can't add beam on b before adding to b-1 for b>0)
                    
                    beamed = noBeamsOnLevel(beamed: beamed, noteValue: noteValue, position: position, maxBeams: maxBeams, level: b)
                    
                }else{ // beams on "level" b
                    beamed = beamsOnLevel(beamed: beamed, noteValue: noteValue, position: position, maxBeams: maxBeams, level: b, beamsInPosition: beamsInPosition)
                }
            }
            
            return beamed
        }
        
        
        func beamed(noteValue: NoteValue){
            var noteValue = noteValue
            var beamed = Beamed()
            var position = 0
            
            while (i < rhythm.noteValues.count && isBeamed(noteValue: noteValue)) {
                beamed.dots.append(noteValue.dots)
                beamed.accents.append(noteValue.accent)
                
                let numOfDivisions: Int = Int(log2(Double(maxFraction/gcd(sum: sum + maxFraction/noteValue.baseFraction))))
                
                let maxBeams: Int = numOfDivisions + Int(log2(Double(timeSignatureNoteValue.rawValue))) - beamNumOffset
                
                //This is super wrong?
                if(i+1 < rhythm.noteValues.count && !isBeamed(noteValue: rhythm.noteValues[i+1]) && beamed.dots.isEmpty){ // if beam properties have split a beamed and you get an isolated on the right side
                    appendIsolated(noteValue: noteValue)
                }
                
                beamed = processNoteValueBeams(beamed: beamed, noteValue: noteValue, position: position, maxBeams: maxBeams)
                
                if(maxBeams == 0){
                    position = 0
                }else{
                    position += 1
                }
                
                i += 1
                
                if(i < rhythm.noteValues.count){
                    noteValue = rhythm.noteValues[i]
                }
            }
            
            rhythmComponents.append(beamed)
        }
        
        
        while (i < rhythm.noteValues.count) {
            let noteValue = rhythm.noteValues[i]
            
            if !isBeamed(noteValue: noteValue) { // isRest or !isBeamed
                appendIsolated(noteValue: noteValue)
            } else { // isBeamed
                if i+1 < rhythm.noteValues.count && isBeamed(noteValue: rhythm.noteValues[i+1]){ //not isolated
                    beamed(noteValue: noteValue)
                } else { // isolated
                    appendIsolated(noteValue: noteValue)
                }
            }
        }
        
        return rhythmComponents
    }
}

class RhythmComponent: Identifiable {
    var id = UUID()
}

class Beamed: RhythmComponent{
    var beams: [[Beam]] = []
    var dots: [Int] = []
    var accents: [Bool] = []
}

class Isolated: RhythmComponent{
    let noteValue: NoteValue
    
    init(noteValue: NoteValue){
        self.noteValue = noteValue
    }
}

struct Beam: Identifiable {
    var id = UUID()
    var startPosition: Int
    var length: Int = 0
}

struct RhythmView_Previews: PreviewProvider {
    static var previews: some View {
        RhythmView(rhythm: Rhythm(), timeSignatureNoteValue: .QUARTER, geometry: .zero)
    }
}
