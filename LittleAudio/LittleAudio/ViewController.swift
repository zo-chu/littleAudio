//
//  ViewController.swift
//  LittleAudio
//
//  Created by MacBook on 14/09/2020.
//  Copyright © 2020 MacBook. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    let signalSource: SignalSource = SignalSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        askForRecordingPermission()
        
    }
    
    func askForRecordingPermission() {
        let session: AVAudioSession = AVAudioSession.sharedInstance()
        if (session.responds(to: #selector(AVAudioSession.requestRecordPermission(_:)))) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    print("granted")
                    do {
                        try session.setCategory(AVAudioSession.Category.playAndRecord)
                        try session.setActive(true)
                    }
                    catch {
                        print("Couldn't set  AVAudioSession category")
                        return
                    }
                    self.signalSource.start()
                } else{
                    print("permission not granted")
                }
            })
        }
    }
   
}

