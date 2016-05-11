//
//  RiskScoreViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/11/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import GaugeKit
import KeychainSwift

class RiskScoreViewController: UIViewController {
    
    let g = Gauge()

    let l = Gauge()
    
    let lbl = UILabel()
    
    let bg = UIImageView()
    
    let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setData()
    }

    func configureView() {
        
        g.frame = CGRect(x: 50, y: 70, width: self.view.layer.frame.width-100, height: 250)
        g.startColor = UIColor.greenColor()
        g.contentMode = .ScaleAspectFit
        g.shadowRadius = 40
        g.shadowOpacity = 0.01
        g.lineWidth = 1
        g.maxValue = 100
        self.view.addSubview(g)
        
        l.frame = CGRect(x: 120, y: 270, width: self.view.layer.frame.width-240, height: 200)
        l.type = .Line
        l.endColor = UIColor.greenColor()
        l.startColor = UIColor.orangeColor()
        l.contentMode = .ScaleAspectFit
        l.shadowRadius = 40
        l.shadowOpacity = 0.01
        l.lineWidth = 1
        l.maxValue = 100
        self.view.addSubview(l)
        
        lbl.frame = CGRect(x: 50, y: 50, width: self.view.layer.frame.width-100, height: 250)
        lbl.textColor = UIColor.whiteColor()
        lbl.textAlignment = .Center
        lbl.font = UIFont(name: "AvenirNext-UltraLight", size: 40)
        self.view.addSubview(lbl)
        
        titleLabel.frame = CGRect(x: 50, y: 90, width: self.view.layer.frame.width-100, height: 250)
        titleLabel.text = "Risk Score"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "AvenirNext-UltraLight", size: 18)
        self.view.addSubview(titleLabel)
        
        bg.frame = CGRect(x: 0, y: 0, width: self.view.frame.width+1, height: self.view.frame.height-250)
        bg.image = UIImage(named: "BackgroundGradientInverseCurved")
        bg.contentMode = .ScaleAspectFill
        self.view.addSubview(bg)
        self.view.sendSubviewToBack(bg)
        
    }
    
    func setData() {
        let score = KeychainSwift().get("riskScore")
        let floatScore = Float(score!)

        if(score == nil) {
            lbl.text = "N/A"
            g.startColor = UIColor.darkBlue()
            g.rate = 100
            l.rate = 100
        } else {
            lbl.text = String(Int(floatScore!*100))
            g.rate = CGFloat(floatScore!)*100
            l.rate = CGFloat(floatScore!)*100
            
            if(g.rate >= 80) {
                g.startColor = UIColor.greenColor()
            } else if(g.rate > 60) {
                g.startColor = UIColor.yellowColor()
            } else if(g.rate > 40) {
                g.startColor = UIColor.orangeColor()
            } else {
                g.startColor = UIColor.redColor()
            }
        }

    }
    
}