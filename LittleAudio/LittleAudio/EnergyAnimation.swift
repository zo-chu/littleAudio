//
//  EnergyAnimation.swift
//  LittleAudio
//
//  Created by MacBook on 16/09/2020.
//  Copyright © 2020 MacBook. All rights reserved.
//

import Foundation
import UIKit

typealias GetEnergy = () -> CGFloat


class EnergyAnimation {

    let normalEnergyMaxDiameter: CGFloat = 295
    let peakEnergyMaxDiameter: CGFloat = 454

    typealias EnergyAnimationSizes = (normalDiameter:CGFloat, peakDiameter:CGFloat)

    let startingDiameter: CGFloat = 100.0 //that it's not int is weired
    

    // MARK: - sizes
    struct Diameters {
        let normalRangeTop: CGFloat
        let peakRangeTop : CGFloat
        let startingPoint: CGFloat
    }
    
    // MARK: - consts

    let BORDER_FADE_OUT_DURATION: CFTimeInterval = 1
    let SCALING_DURATION: CFTimeInterval = 0.5
    let UPDATES_PER_SEC = 25
    let PEAK_ENERGY_COLOR = UIColor.red.cgColor
    let NORMAL_ENERGY_COLOR = UIColor.green.cgColor
    
    let tooHighEnergy : CGFloat!
    
    // MARK: -
    
    private var anchorLayer: CALayer!
    private var outerLayer: CALayer!
    private var displayLink: CADisplayLink?
    
    private let diameters: Diameters
    
    // MARK: - input functions

    private var energyValue: GetEnergy!
    
    // MARK: -
    var highestPeak : CGFloat? = nil
    var displayingPeak = false
    
    // MARK: - init
    
    init(below anchor: CALayer, getEnergy: @escaping GetEnergy){
        
        anchorLayer = anchor
        
        let normalDiameter =  normalEnergyMaxDiameter
        let peakDiameter =   peakEnergyMaxDiameter
        
        diameters = Diameters(normalRangeTop: normalDiameter, peakRangeTop: peakDiameter, startingPoint: startingDiameter)
        self.energyValue = getEnergy
        self.tooHighEnergy = 0.9
        
        let outerLayerPosition = CGPoint(x: anchor.bounds.midX, y:  anchor.bounds.midY)
        
        outerLayer = createLayer(radius: diameters.peakRangeTop / 2, position: outerLayerPosition)
        outerLayer.transform = CATransform3DMakeScale(0, 0, 1)//hidden

        outerLayer.backgroundColor = NORMAL_ENERGY_COLOR
        outerLayer.add(createOuterScaleAnimation(), forKey: "scale")
    }

    // MARK: - public


    func start(){
        displayLink = CADisplayLink(target: self, selector: #selector(self.update))
        displayLink?.preferredFramesPerSecond = UPDATES_PER_SEC
        displayLink?.add(to: .current, forMode: .common)
        
        anchorLayer.insertSublayer(outerLayer, below: anchorLayer)
    }
    
    func stop(){
        displayLink?.remove(from: .current, forMode: .common)
        displayLink = nil
        outerLayer.removeFromSuperlayer()
    }
    
    // MARK: -

    @objc func update(){
        
        let inputValue = energyValue()
        let newDiameter = getNewDiameter(inputValue: inputValue)
        let multiplier = getDiameterMultiplier(with: newDiameter)
        
        outerLayer.transform = CATransform3DMakeScale(multiplier, multiplier, 1)

        if(inputValue > tooHighEnergy){
            outerLayer.backgroundColor = PEAK_ENERGY_COLOR
            highestPeak = newDiameter
        }else{
            outerLayer.backgroundColor = NORMAL_ENERGY_COLOR
            
            if(highestPeak != nil){
                dispatchPeakEnergy(with: highestPeak! / 2)
            }
            
            highestPeak = nil
        }
    }
    
    // MARK: - get values
    
    func getNewDiameter(inputValue: CGFloat) -> CGFloat {
        
        if(inputValue < tooHighEnergy){
            return diameters.startingPoint + CGFloat((normalEnergyMaxDiameter - startingDiameter))  * (inputValue / tooHighEnergy)
            
        }
        
        let propVal = (inputValue - tooHighEnergy) / (1 - tooHighEnergy)
        return  diameters.normalRangeTop + CGFloat((peakEnergyMaxDiameter - normalEnergyMaxDiameter)) * propVal
    }
    
    private func getDiameterMultiplier(with width: CGFloat) -> CGFloat{
        return width / CGFloat(peakEnergyMaxDiameter)
    }
    
    // MARK: -

    private func dispatchPeakEnergy(with radius: CGFloat){
        if (displayingPeak){
            return
        }

        let peakEnergyLayer = createPeakEnergyLayer(with:radius)
        displayingPeak = true
        anchorLayer.addSublayer(peakEnergyLayer)
    }
    
    // MARK: - create layers

    private func createPeakEnergyLayer(with radius: CGFloat) -> CALayer{
        let layerPosition = CGPoint(x: anchorLayer.bounds.midX, y:  anchorLayer.bounds.midY)
        let layer = createLayer(radius: radius, position: layerPosition)
        layer.borderColor = PEAK_ENERGY_COLOR
        layer.borderWidth = 1
        layer.backgroundColor = UIColor.clear.cgColor
        
        CATransaction.begin()
        let animation = createOpacityAnimation()
        layer.opacity = 0
        
        CATransaction.setCompletionBlock {
            layer.removeFromSuperlayer()
            self.displayingPeak = false
        }
        
        layer.add(animation, forKey: "fadeOut")
        CATransaction.commit()
        
        return layer
    }
    
    func createLayer(radius:CGFloat, position:CGPoint)-> CALayer{
        let layer = CALayer()
        layer.contentsScale = UIScreen.main.scale
        layer.opacity = 1
        layer.position = position
        layer.bounds = CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)
        layer.cornerRadius = radius
        return layer
    }
    
    // MARK: - create animations
    
    private func createOpacityAnimation() -> CABasicAnimation{
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = BORDER_FADE_OUT_DURATION
        animation.fromValue = 1
        animation.toValue = 0
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        return animation
    }
    
    private func createOuterScaleAnimation () -> CABasicAnimation {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = 1
        scaleAnimation.duration = SCALING_DURATION
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        return scaleAnimation
    }
}
