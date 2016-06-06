//
//  RiskTutorialViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/11/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import MZFormSheetPresentationController

class RiskTutorialViewController: UIViewController {
    
    let titleLabel = UILabel()

    let descriptionLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This will set to only one instance
        
        self.view.backgroundColor = UIColor.mediumBlue()
        
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        _ = screen.size.width
        _ = screen.size.height
        
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGrayColor()
        
        titleLabel.frame = CGRect(x: 0, y: 35, width: 300, height: 20)
        titleLabel.text = "Tutorial"
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont.systemFontOfSize(18, weight: UIFontWeightLight)
        titleLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(titleLabel)
        
        descriptionLabel.frame = CGRect(x: 20, y: 70, width: 260, height: 150)
        descriptionLabel.text = "This is your risk profile. It's value ranges from 0-100 and provides an overall risk assessment based on your financial situation among other proprietary calculations.  The current risk profile values are Perfect, Great, Good, Average, and Poor. Contact support for more information regarding risk profiling."
        descriptionLabel.numberOfLines = 0
        descriptionLabel.alpha = 0.8
        descriptionLabel.textAlignment = .Center
        descriptionLabel.font = UIFont.systemFontOfSize(12, weight: UIFontWeightRegular)
        descriptionLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(descriptionLabel)
        
        
    }
    
    override func viewDidDisappear(animated: Bool) {
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    func close() -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}