//
//  MeasureBeatView.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 20/07/2020.
//

import SwiftUI

struct MeasureBeatView: View {
    @EnvironmentObject var metronomeEnvironment: MetronomeEnvironment
    
    let beat: Beat
    
    init(beat: Beat, timeSignatureNoteValue: NoteValueFraction, replaceInvalidRhythm: (Int) -> ()){
        self.beat = beat
        
        if(!beat.rhythm.isValid(timeSignatureNoteValue: timeSignatureNoteValue)){
            replaceInvalidRhythm(beat.id)
        }
    }
    
    var body: some View {
        ZStack{
            if(metronomeEnvironment.beepOccured && metronomeEnvironment.beatPlaying == beat.id){
                RoundedRectangle(cornerRadius: 6)
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundColor(.green)
                    .onAppear(perform: metronomeEnvironment.beepOccuredDisplayed)
            }
            
            BeatView(rhythm: beat.rhythm,
                     timeSignatureNoteValue: metronomeEnvironment.measure.timeSignature.noteValue,
                     compound: metronomeEnvironment.measure.compound,
                     selected: metronomeEnvironment.selectedBeats.contains(beat.id),
                     secondSelected: metronomeEnvironment.multipleBeatsSelectionMode,
                     isValid: !metronomeEnvironment.invalidBeats.contains(beat.id))
                .contentShape(Rectangle())
                .onTapGesture { self.metronomeEnvironment.selectBeat(id: self.beat.id) }
                .onLongPressGesture { self.metronomeEnvironment.selectMultipleBeat(id: self.beat.id) }
        }
    }
}

struct MeasureBeatView_Previews: PreviewProvider {
    static var previews: some View {
        MeasureBeatView(beat: Beat(id: 0, rhythm: Rhythm()), timeSignatureNoteValue: .QUARTER, replaceInvalidRhythm: {_ in})
    }
}
