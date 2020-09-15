//
//  ViewController.swift
//  LittleAudio
//
//  Created by MacBook on 14/09/2020.
//  Copyright © 2020 MacBook. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, VolumeProviderProtocol {
    
    let signalSource: SignalSource = SignalSource()
    var energyIndicator: EnergyIndicator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        askForRecordingPermission()
    }
    
    func getCurrentEnergy() -> CGFloat {
        return signalSource.getEnergyPercent()
    }
    
    func addIndicator() {
        self.signalSource.start()

        energyIndicator = EnergyIndicator(frame: CGRect(x: 0, y: 0, width: 200, height: 50), volumeProvider: self)

        self.view.addSubview(energyIndicator!)

        energyIndicator!.setup()
        energyIndicator!.startAnimating()
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
                    self.addIndicator()
                } else{
                    print("permission not granted")
                }
            })
        }
    }
   
}

