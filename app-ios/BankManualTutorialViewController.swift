//
//  BankManualTutorialViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 6/17/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import MZFormSheetPresentationController

class BankManualTutorialViewController: UIViewController {
    
    let titleLabel = UILabel()
    
    let exampleImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This will set to only one instance
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        _ = screen.size.width
        _ = screen.size.height
        
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGrayColor()
        
        titleLabel.frame = CGRect(x: 0, y: 35, width: 300, height: 20)
        titleLabel.text = "Example Check"
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont.systemFontOfSize(18, weight: UIFontWeightLight)
        titleLabel.textColor = UIColor.lightBlue()
        self.view.addSubview(titleLabel)
        
        exampleImage.frame = CGRect(x: 50, y: 80, width: 200, height: 200)
        exampleImage.image = UIImage(named: "IconCheckExample")
        exampleImage.contentMode = .ScaleAspectFit
        self.view.addSubview(exampleImage)
        
        
    }
    
    override func viewDidDisappear(animated: Bool) {
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    func close() -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}