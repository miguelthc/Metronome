//
//  NoteValue.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 12/07/2020.
//

import Foundation
import SwiftUI

struct NoteValue: Identifiable {
    var id = UUID()
    var baseFraction: Int = 1
    var isRest: Bool = false
    var accent: Bool = false
    var dots: Int = 0
    
    var fractionOfBeat: Double {
        get{
            var sum = 1.0/Double(baseFraction)
            
            if(isDotted()){
                sum += NoteValue.dotSum(baseFraction: baseFraction, dots: dots)
            }
            
            return sum
        }
    }
}

extension NoteValue: Equatable, Hashable {
    static func == (lhs: NoteValue, rhs: NoteValue) -> Bool {
        return lhs.id == rhs.id && lhs.baseFraction == rhs.baseFraction && lhs.isRest == rhs.isRest && lhs.accent == rhs.accent && lhs.dots == rhs.dots
    }
    
    static func != (lhs: NoteValue, rhs: NoteValue) -> Bool {
        return lhs.id != rhs.id || lhs.baseFraction != rhs.baseFraction || lhs.isRest != rhs.isRest || lhs.accent != rhs.accent || lhs.dots != rhs.dots
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(baseFraction)
        hasher.combine(isRest)
        hasher.combine(accent)
        hasher.combine(dots)
    }
    
    
}

extension NoteValue {
    func image(timeSignatureNoteValue: NoteValueFraction, relativeHeight: CGFloat) -> AnyView {
        return AnyView(
            HStack(alignment: .bottom, spacing: isFlagged(timeSignatureNoteValue: timeSignatureNoteValue) ? relativeHeight/20 : relativeHeight/3.14/3){
                
                if !isRest {
                    ZStack(alignment: .bottom){
                        NoteValue.noteValueView(relativeHeight: relativeHeight, fractionOfBeat: baseFraction, timeSignatureNoteValue: timeSignatureNoteValue)
                        
                        if accent {
                            Accent(relativeHeight: relativeHeight).offset(y: relativeHeight/3)
                        }
                    }
                } else {
                    NoteValue.restView(relativeHeight: relativeHeight, fractionOfBeat: baseFraction, timeSignatureNoteValue: timeSignatureNoteValue)
                }
                
                HStack(spacing: relativeHeight/16) {
                    if(isDotted()){
                        ForEach (1...dots, id: \.self){ _ in
                            NoteValue.addDots(relativeHeight: 40)
                        }
                    }
                }
            }
        )
    }
    
    
    func isDotted() -> Bool {
        return dots > 0
    }
    
    
    func isFlagged(timeSignatureNoteValue: NoteValueFraction) -> Bool {
        return baseFraction * timeSignatureNoteValue.rawValue > NoteValueFraction.QUARTER.rawValue && !isRest
    }
    
    static func dotSum(baseFraction: Int, dots: Int) -> Double {
        var dotSum = 0.0
        
        if (dots > 0) {
            for dot in 1...dots {
                dotSum += 1.0/(Double(baseFraction)*pow(Double(2), Double(dot)))
            }
        }
        
        return dotSum
    }
    
    static func addDots(relativeHeight: CGFloat) -> some View {
        Dot(relativeHeight: relativeHeight)
            .offset(y: -relativeHeight/7.63 + relativeHeight/3.14/6)
        
    }
}

extension NoteValue {
    
    static func noteValueView(relativeHeight: CGFloat, fractionOfBeat: Int, timeSignatureNoteValue: NoteValueFraction) -> AnyView {
        switch (fractionOfBeat * timeSignatureNoteValue.rawValue) {
            case NoteValueFraction.WHOLE.rawValue:
                return AnyView(WholeNote(relativeHeight: relativeHeight))
            case NoteValueFraction.HALF.rawValue:
                return AnyView(HalfNote(relativeHeight: relativeHeight))
            case NoteValueFraction.QUARTER.rawValue:
                return AnyView(QuarterNote(relativeHeight: relativeHeight))
            case NoteValueFraction.EIGHTH.rawValue:
                return AnyView(EighthNote(relativeHeight: relativeHeight))
            case NoteValueFraction.SIXTEENTH.rawValue:
                return AnyView(SixteenthNote(relativeHeight: relativeHeight))
            case NoteValueFraction.THIRTY_SECOND.rawValue:
                return AnyView(ThirtySecondNote(relativeHeight: relativeHeight))
            case NoteValueFraction.SIXTY_FOURTH.rawValue:
                return AnyView(SixtyFourthNote(relativeHeight: relativeHeight))
            case NoteValueFraction.ONE_HUNDRED_TWENTY_EIGHTH.rawValue:
                return AnyView(OneHundredTwentyEighthNote(relativeHeight: relativeHeight))
            default:
                return AnyView(EmptyView())
        }
    }
    
    static func restView(relativeHeight: CGFloat, fractionOfBeat: Int, timeSignatureNoteValue: NoteValueFraction) -> AnyView {
        switch (fractionOfBeat * timeSignatureNoteValue.rawValue) {
            case NoteValueFraction.WHOLE.rawValue:
                return AnyView(WholeRest(relativeHeight: relativeHeight))
            case NoteValueFraction.HALF.rawValue:
                return AnyView(HalfRest(relativeHeight: relativeHeight))
            case NoteValueFraction.QUARTER.rawValue:
                return AnyView(QuarterRest(relativeHeight: relativeHeight))
            case NoteValueFraction.EIGHTH.rawValue:
                return AnyView(EighthRest(relativeHeight: relativeHeight))
            case NoteValueFraction.SIXTEENTH.rawValue:
                return AnyView(SixteenthRest(relativeHeight: relativeHeight))
            case NoteValueFraction.THIRTY_SECOND.rawValue:
                return AnyView(ThirtySecondRest(relativeHeight: relativeHeight))
            case NoteValueFraction.SIXTY_FOURTH.rawValue:
                return AnyView(SixtyFourthRest(relativeHeight: relativeHeight))
            case NoteValueFraction.ONE_HUNDRED_TWENTY_EIGHTH.rawValue:
                return AnyView(OneHundredTwentyEighthRest(relativeHeight: relativeHeight))
            default:
                return AnyView(EmptyView())
        }
    }
    
    //Implement later
    func widthQ(compound: Bool){
        //switch(){
            
        //}
    }
}
