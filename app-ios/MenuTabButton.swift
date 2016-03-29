//
//  MenuTabButton.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 3/28/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import DCPathButton

class MenuTabButtonViewController: UIViewController, DCPathButtonDelegate {
    
    var dcPathButton:DCPathButton!
    var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("loaded menu button")
    
        configureDCPathButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureDCPathButton() {

        dcPathButton = DCPathButton(centerImage: UIImage(named: "chooser-button-tab"), highlightedImage: UIImage(named: "chooser-button-tab-highlighted"))
        
        dcPathButton.delegate = self
        dcPathButton.dcButtonCenter = CGPointMake(self.view.bounds.width/2, self.view.bounds.height - 25.5)
        dcPathButton.allowSounds = true
        dcPathButton.allowCenterButtonRotation = true
        
        dcPathButton.bloomRadius = 105
        
        let itemButton_1 = DCPathItemButton(image: UIImage(named: "chooser-moment-icon-music"), highlightedImage: UIImage(named: "chooser-moment-icon-music-highlighted"), backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted"))
        let itemButton_2 = DCPathItemButton(image: UIImage(named: "chooser-moment-icon-place"), highlightedImage: UIImage(named: "chooser-moment-icon-place-highlighted"), backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted"))
        let itemButton_3 = DCPathItemButton(image: UIImage(named: "chooser-moment-icon-camera"), highlightedImage: UIImage(named: "chooser-moment-icon-camera-highlighted"), backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted"))
        let itemButton_4 = DCPathItemButton(image: UIImage(named: "chooser-moment-icon-thought"), highlightedImage: UIImage(named: "chooser-moment-icon-thought-highlighted"), backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted"))
        let itemButton_5 = DCPathItemButton(image: UIImage(named: "chooser-moment-icon-sleep"), highlightedImage: UIImage(named: "chooser-moment-icon-sleep-highlighted"), backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted"))
        
        
        dcPathButton.addPathItems([itemButton_1, itemButton_2, itemButton_3, itemButton_4, itemButton_5])
        
        self.view.addSubview(dcPathButton)
        
    }
    
    // DCPathButton Delegate
    //
    func pathButton(dcPathButton: DCPathButton!, clickItemButtonAtIndex itemButtonIndex: UInt) {
        
        var alertView = UIAlertView(title: "", message: "You tap at index \(itemButtonIndex)", delegate: nil, cancelButtonTitle: "Ok")
        
        alertView.show()
        
    }
    
}
