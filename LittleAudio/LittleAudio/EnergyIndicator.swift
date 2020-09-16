//
//  EnergyIndicator.swift
//  LittleAudio
//
//  Created by MacBook on 15/09/2020.
//  Copyright © 2020 MacBook. All rights reserved.
//

import Foundation
import UIKit

protocol EnergyProviderProtocol {
    func getCurrentEnergy() -> CGFloat
}

class EnergyIndicator: UIView{
    var isAnimating = false

    var pulsingAnimation: PulsingAnimation?
    var energyAnimation: EnergyAnimation?
  
    let PULSING_MULTIPLIER : CGFloat = 0.8
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var energyHost: UIView!
    @IBOutlet weak var energyView: UIView!
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var icon: UIImageView!
    
    var energyProvider: EnergyProviderProtocol?
    
    // MARK: - inits

    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    init(frame: CGRect, energyProvider: EnergyProviderProtocol){
        super.init(frame: frame)
        self.energyProvider = energyProvider
        commonInit()
    }
    
    private func commonInit(){
        let name = String(describing: type(of: self))
        let nib = UINib(nibName: name, bundle: .main)
        nib.instantiate(withOwner: self, options: nil)
        
        self.addSubview(self.contentView)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            ])
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: -

    override func layoutSubviews() {
        super.layoutSubviews()
    }
 
    // MARK: - public methods
    
    public func startAnimating(){
        guard !isAnimating else { return }
        isAnimating = true

        pulsingAnimation?.start()
        energyAnimation?.start()
    }

    // MARK: - setup

    
    func setup(){
        setUpPulsingView()
        setUpEnergyView()
    }
    
    private func setUpPulsingView() {
        iconView.layer.cornerRadius = iconView.frame.size.width/2
        iconView.clipsToBounds = false
        iconView.backgroundColor = UIColor.blue
        pulsingAnimation = PulsingAnimation.init(layer: iconView.layer, multiplier: PULSING_MULTIPLIER)
    }
    
    private func setUpEnergyView(){
        energyHost.clipsToBounds = false
        
        if energyProvider == nil{
            return
        }
        
        energyAnimation = EnergyAnimation(below: energyHost.layer, getEnergy: energyProvider!.getCurrentEnergy)
    }
    
}
