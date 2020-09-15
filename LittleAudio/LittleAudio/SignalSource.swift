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

    func getEnergyPercent() -> CGFloat {
        let result = CGFloat(recorder.averagePower(forChannel: 0))
        return (pow (10, (0.05 * result)))
        
    }
    
    private func getDocumentsDirectory() -> URL {
           let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
           return paths[0]
    }
       
   private func startRecording() {
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
   }
}
