//
//  EnergyIndicator.swift
//  LittleAudio
//
//  Created by MacBook on 15/09/2020.
//  Copyright © 2020 MacBook. All rights reserved.
//

import Foundation
import UIKit

protocol VolumeProviderProtocol {
    func getCurrentEnergy() -> CGFloat
}

class EnergyIndicator: UIView{
    
    var isAnimating = false

    //TODO
    //add beaming animation
    //add dynamic animation
  
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var energyHost: UIView!
    @IBOutlet weak var energyView: UIView!
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var icon: UIImageView!
    
    var volumeProvider: VolumeProviderProtocol?

    // MARK: - inits

    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    init(frame: CGRect, volumeProvider: VolumeProviderProtocol){
        super.init(frame: frame)
        self.volumeProvider = volumeProvider
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

        //start beaming
        //start energy
    }

    // MARK: - setup

    
    func setup(){
        //TODO
        //setup small view
        //setup dynamic view
    }
}
