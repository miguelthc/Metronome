//
//  AudioEngine.swift
//  MusicApp
//
//  Created by Miguel Carvalho on 12/07/2020.
//

import Foundation
import AVFoundation

class AudioEngine {
    private let audioEngine = AVAudioEngine()
    private var sourceNode: AVAudioSourceNode
    
    private let sampleRate: Double
    private let inputFormat: AVAudioFormat
    
    init(renderFunction: @escaping (Float, UInt64) -> Float){
        let output = audioEngine.outputNode
        let format = output.inputFormat(forBus: 0)
        sampleRate = format.sampleRate
        
        sourceNode = AVAudioSourceNode(renderBlock: {_,_,_,_ -> OSStatus in return noErr})

        inputFormat = AVAudioFormat(commonFormat: format.commonFormat,
                                        sampleRate: sampleRate,
                                        channels: 1,
                                        interleaved: format.isInterleaved)!
        
        setSourceNode(renderFunction: renderFunction)
    }
    
    private func setSourceNode(renderFunction: @escaping (Float, UInt64) -> Float) {
        self.sourceNode = AVAudioSourceNode(renderBlock: setRenderBlock(renderFunction: renderFunction))
        
        audioEngine.attach(sourceNode)
        audioEngine.connect(sourceNode, to: self.audioEngine.mainMixerNode, format: self.inputFormat)
    }
    
    private func setRenderBlock(renderFunction: @escaping (Float, UInt64) -> Float) -> AVAudioSourceNodeRenderBlock {
        let deltaTime = 1.0 / Float(sampleRate)
        
        return { silence, timeStamp, frameCount, audioBufferList -> OSStatus in
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
                    
            for frame in 0..<Int(frameCount) {
                let value = renderFunction(deltaTime, timeStamp.pointee.mHostTime)
                for buffer in ablPointer {
                    let buf: UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
                    buf[frame] = value
                }
            }
            
            return noErr
        }
    }
    
    func newSourceNode(renderFunction: @escaping (Float, UInt64) -> Float) {
        audioEngine.detach(sourceNode)
        setSourceNode(renderFunction: renderFunction)
    }
    
    func startEngine() {
        audioEngine.prepare()
        try! audioEngine.start()
    }
    
    func stopEngine() {
        audioEngine.stop()
    }
    
}
