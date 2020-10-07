//
//  ViewController.swift
//  LittleAudio
//
//  Created by MacBook on 14/09/2020.
//  Copyright © 2020 MacBook. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, EnergyProviderProtocol {
    
    let signalSource: SignalSource = SignalSource()
    var energyIndicator: EnergyIndicator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addIndicator()
    }
    
    func getCurrentEnergy() -> CGFloat {
        return signalSource.getAverageEnergy()
    }
    
    func addIndicator() {
        self.signalSource.startRecording()

        energyIndicator = EnergyIndicator(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.width), energyProvider: self)

        self.view.addSubview(energyIndicator!)

        energyIndicator!.setup()
        energyIndicator!.startAnimating()
    }
}

