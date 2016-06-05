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
import EmitterKit
import CWStatusBarNotification

class BitcoinUriViewController: UIViewController {
    
    var bitcoinId: String?
    
    var bitcoinUri: String?
    
    var bitcoinAmount: Float?
    
    var bitcoinFilled: Bool?
    
    let qrImageView = UIImageView()
    
    let bitcoinAmountLabel = UILabel()

    let bitcoinFilledSignal = Signal()
    
    var bitcoinFilledListener: Listener?
    
    var bitcoinPoller:NSTimer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This will set to only one instance
        
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        _ = screen.size.width
        _ = screen.size.height
        
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGrayColor()
        
        qrImageView.frame = CGRect(x: 25, y: 25, width: 200, height: 200)
        
        qrImageView.image = {
            var qrCode = QRCode(bitcoinUri!)
            // print("got bitcoin uri", bitcoinUri)
            qrCode?.image
            qrCode!.errorCorrection = .High
            qrCode!.color = CIColor(CGColor: UIColor.mediumBlue().CGColor)
            return qrCode!.image
        }();
        self.view.addSubview(qrImageView)
        
        bitcoinAmountLabel.frame = CGRect(x: 25, y: 230, width: 200, height: 50)
        bitcoinAmountLabel.backgroundColor = UIColor.offWhite()
        bitcoinAmountLabel.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.2).CGColor
        bitcoinAmountLabel.layer.cornerRadius = 10
        bitcoinAmountLabel.layer.borderWidth = 1
        // convert satoshi to bitcoin divide by 10^8
        bitcoinAmountLabel.text = String(bitcoinAmount!/100000000) + " BTC"
        bitcoinAmountLabel.textAlignment = .Center
        bitcoinAmountLabel.textColor = UIColor.lightBlue()
        bitcoinAmountLabel.font = UIFont(name: "HelveticaNeue-Light", size: 18)!
        self.view.addSubview(bitcoinAmountLabel)
        
        // Flow | Bitcoin
        // Send request to get the bitcoin receiver by id
        // This is essentially polling, but once the receiver is
        // filled then emit event that the bitcoin receiver is filled
        // thereby closing the bitcoin modal window
        // and display a notification alert saying bitcoin was paid
        // print("is bitcoin receiver for bitcoin id " + bitcoinId! + " filled? ", bitcoinFilled)
        
        // make REST call to bitcoin receiver to retrieve bitcoin filled status
        // if the status if filled, emit an event saying that the bitcoin receiver
        // is filled and this will dismiss modal window
        
        // Be careful with timers, they can cause memory leaks if not
        // explicitly removed / destroyed
        
        bitcoinPoller = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: #selector(self.pollBitcoinReceiver(_:)), userInfo: nil, repeats: true)
    }
    

    func pollBitcoinReceiver(sender: AnyObject) {
        
        // print("polling bitcoin")
        Bitcoin.getBitcoinReceiver(bitcoinId!) { (bitcoin, err) in
            //print(bitcoin?.id)
            //print("bitcoin filled status ", bitcoin!.filled)
            if bitcoin?.filled == true {
                // print("invalidating timer")
                self.bitcoinPoller!.invalidate()
                self.dismissViewControllerAnimated(true, completion: {
                    // print("bitcoin receiver for bitcoin id " + self.bitcoinId! + " filled!")
                    showGlobalNotification(String((bitcoin?.amount)!/100000000) + " BTC received!", duration: 5.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.bitcoinOrange())
                })
            }
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        
    }
    
    func close() -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}