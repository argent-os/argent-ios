//
//  RiskScoreViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/11/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import GaugeKit

class RiskScoreViewController: UIViewController {
    
    let g = Gauge()

    let l = Gauge()
    
    let s = UISlider()

    let lbl = UILabel()
    
    let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }

    func sliderValueChanged(sender: UISlider) {
        let val = Int(sender.value)
        g.rate = CGFloat(val)
        l.rate = CGFloat(val)
        lbl.text = String(val)
    }
    
    func configureView() {
        s.frame = CGRect(x: 50, y: self.view.layer.frame.height-200, width: self.view.layer.frame.width-100, height: 100)
        s.maximumValue = 10
        s.minimumValue = 0
        s.addTarget(self, action: #selector(RiskScoreViewController.sliderValueChanged(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(s)
        
        g.frame = CGRect(x: 50, y: 70, width: self.view.layer.frame.width-100, height: 250)
        g.endColor = UIColor.greenColor()
        g.startColor = UIColor.greenColor()
        g.contentMode = .ScaleAspectFit
        g.shadowRadius = 40
        g.shadowOpacity = 0.01
        g.lineWidth = 1
        g.maxValue = 10
        self.view.addSubview(g)
        
        l.frame = CGRect(x: 120, y: 270, width: self.view.layer.frame.width-240, height: 200)
        l.type = .Line
        l.endColor = UIColor.greenColor()
        l.startColor = UIColor.orangeColor()
        l.contentMode = .ScaleAspectFit
        l.shadowRadius = 40
        l.shadowOpacity = 0.01
        l.lineWidth = 1
        l.maxValue = 10
        self.view.addSubview(l)
        
        lbl.frame = CGRect(x: 50, y: 70, width: self.view.layer.frame.width-100, height: 250)
        lbl.text = "0"
        lbl.textColor = UIColor.darkGrayColor()
        lbl.textAlignment = .Center
        lbl.font = UIFont(name: "AvenirNext-UltraLight", size: 48)
        self.view.addSubview(lbl)
        
    }
    
}