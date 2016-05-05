//
//  BitcoinUriViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/5/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit
import MZFormSheetPresentationController
import QRCode

class BitcoinUriViewController: UIViewController {
    
    var bitcoinUri: String?
    
    let qrImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This will set to only one instance
        
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGrayColor()
        
        qrImageView.frame = CGRect(x: 25, y: 25, width: 200, height: 200)
        qrImageView.image = {
            var qrCode = QRCode(bitcoinUri!)
            print("got bitcoin uri", bitcoinUri)
            qrCode?.image
            qrCode!.errorCorrection = .High
            qrCode!.color = CIColor(CGColor: UIColor.mediumBlue().CGColor)
            return qrCode!.image
        }();
        
        self.view.addSubview(qrImageView)
    }
    
    override func viewDidDisappear(animated: Bool) {
        
    }
    
    func close() -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}