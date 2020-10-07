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
    var audioRecorder:AVAudioRecorder?
    let recordingSession = AVAudioSession.sharedInstance()
    var levelTimer: Timer?
    
    override init() {
        super.init()
        startRecording()
    }
    func initalizeRecorder ()
     {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)
            try AVAudioSession.sharedInstance().setActive(true)
        }catch {
            print(error);
        }

        let stringDir:NSString = self.getDocumentsDirectory() as NSString;
        let audioFilename = stringDir.appendingPathComponent("recording.m4a")
        let audioURL = NSURL(fileURLWithPath: audioFilename)
        print("Path to file : \(audioFilename)");

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000.0,
            AVNumberOfChannelsKey: 1 as NSNumber,
            AVEncoderBitRateKey:12800 as NSNumber,
            AVLinearPCMBitDepthKey:16 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ] as [String : Any]

        do {
            audioRecorder = try AVAudioRecorder(url: audioURL as URL, settings: settings )
            audioRecorder!.delegate = self
            audioRecorder!.prepareToRecord();
            audioRecorder!.isMeteringEnabled = true;
            audioRecorder!.record()
         } catch {
            print("Could not start audio recorder")
        }
     }
    
    func startRecording() {
        recordingSession.requestRecordPermission() { [unowned self] (allowed: Bool) -> Void in
            if allowed {
                print("Permission to record granted")
                self.initalizeRecorder()
                self.audioRecorder!.record()
            } else {
                print("Permission to record denied")
            }
        }
    }
    
    func getDocumentsDirectory() -> String {
         let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
         let documentsDirectory = paths[0]
         return documentsDirectory
    }
    
    func getAverageEnergy() -> CGFloat {
        audioRecorder!.updateMeters()
        let avPowerForChannel : Double = pow(Double(10.0), (0.05) * Double(audioRecorder!.averagePower(forChannel: 0)));
        print(avPowerForChannel)
        return CGFloat(avPowerForChannel)
    }
}

