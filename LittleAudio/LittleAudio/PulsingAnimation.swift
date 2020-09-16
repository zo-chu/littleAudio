//
//  PulsingAnimation.swift
//  LittleAudio
//
//  Created by MacBook on 15/09/2020.
//  Copyright © 2020 MacBook. All rights reserved.
//

import UIKit

class PulsingAnimation {
    let animatedLayer: CALayer!
    let multiplier: CGFloat!
    var duration: CFTimeInterval!
    
    let PULSE_ANIMATION_KEY = "pulsingAnimation"
    
    init(layer: CALayer, multiplier: CGFloat, duration: CFTimeInterval = 1) {
        animatedLayer = layer
        self.multiplier = multiplier
        self.duration = duration
    }
    
    func stop() {
        animatedLayer.removeAnimation(forKey: PULSE_ANIMATION_KEY)
    }
    
    func start() {
        animatedLayer.add(createPulsingAnimation(to: multiplier, duration: duration), forKey: PULSE_ANIMATION_KEY)
    }
    
    private func createPulsingAnimation(to: CGFloat, duration: CFTimeInterval) -> CABasicAnimation{
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        pulseAnimation.duration = duration
        pulseAnimation.toValue = to
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = Float.infinity
        
        return pulseAnimation
    }
}
