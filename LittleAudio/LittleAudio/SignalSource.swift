//
//  SignalSource .swift
//  LittleAudio
//
//  Created by MacBook on 14/09/2020.
//  Copyright © 2020 MacBook. All rights reserved.
//

import Foundation
import AVFoundation

class SignalSource: NSObject, AVAudioRecorderDelegate {
    
    var recorder: AVAudioRecorder = AVAudioRecorder()
    
    func start() {
        startRecording()
    }
    func stop() {
        
    }
    func getDocumentsDirectory() -> URL {
           let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
           return paths[0]
    }
       
   func startRecording() {
       let audioFilename = getDocumentsDirectory().appendingPathComponent("newRecording.m4a")
       
       let settings = [
           AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
           AVSampleRateKey: 12000,
           AVNumberOfChannelsKey: 1,
           AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
       ]

       do {
           recorder = try AVAudioRecorder(url: audioFilename, settings: settings)
           recorder.delegate = self
           recorder.record()
           recorder.isMeteringEnabled = true

       } catch {
           print("Oh no, nothing works =(")
       }
       //can be done much better
       OperationQueue().addOperation({[weak self] in
       repeat {
           self?.recorder.updateMeters()
           self?.performSelector(onMainThread: #selector(self?.updateMeter), with: self, waitUntilDone: false)
           Thread.sleep(forTimeInterval: 0.05) //20 FPS
       } while (true)
    })
   }
       
   @objc func updateMeter(){
       //should be delegated to VC
        print(recorder.averagePower(forChannel: 0) )//in dB from -160 to 0
        print(recorder.peakPower(forChannel: 0)) //should have casting func
   }
}
