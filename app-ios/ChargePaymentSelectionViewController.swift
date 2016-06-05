//
//  ChargeSuccessModalViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 6/4/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit
import TransitionTreasury
import DKCircleButton

class ChargePaymentSelectionViewController: UIViewController {
    
    weak var modalDelegate: ModalViewControllerDelegate?
    
    @IBOutlet weak var backButton: UIButton!
    
    lazy var dismissGestureRecognizer: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.panDismiss(_:)))
        self.view.addGestureRecognizer(pan)
        return pan
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.offWhite()
        // Do any additional setup after loading the view.
        
        configureView()
    }
    
    func configureView() {
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        // Pay with bitcoin button
        let payWithBitcoinButton = DKCircleButton(frame: CGRect(x: 20, y: 40, width: screenWidth/2-20-10, height: screenWidth/2-20-10))
        payWithBitcoinButton.setBackgroundColor(UIColor.clearColor(), forState: .Normal)
        payWithBitcoinButton.setBackgroundColor(UIColor.clearColor(), forState: .Highlighted)
        payWithBitcoinButton.tintColor = UIColor.whiteColor()
        payWithBitcoinButton.setTitleColor(UIColor.lightBlue(), forState: .Normal)
        payWithBitcoinButton.setTitleColor(UIColor.lightBlue().colorWithAlphaComponent(0.5), forState: .Highlighted)
        payWithBitcoinButton.titleLabel?.font = UIFont.systemFontOfSize(16, weight: UIFontWeightLight)
        payWithBitcoinButton.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.5)
        payWithBitcoinButton.borderSize = 1
        payWithBitcoinButton.setTitle("Bitcoin", forState: .Normal)
        payWithBitcoinButton.clipsToBounds = true
        payWithBitcoinButton.clipsToBounds = true
        payWithBitcoinButton.addTarget(self, action: #selector(self.payWithBitcoin(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        Timeout(0.1) {
            addSubviewWithBounce(payWithBitcoinButton, parentView: self, duration: 0.3)
        }
        
        // Pay with card button
        let payWithCardButton = DKCircleButton(frame: CGRect(x: screenWidth/2+10, y: 40, width: screenWidth/2-20-10, height: screenWidth/2-20-10))
        payWithCardButton.setBackgroundColor(UIColor.clearColor(), forState: .Normal)
        payWithCardButton.setBackgroundColor(UIColor.clearColor(), forState: .Highlighted)
        payWithCardButton.tintColor = UIColor.whiteColor()
        payWithCardButton.setTitleColor(UIColor.lightBlue(), forState: .Normal)
        payWithCardButton.setTitleColor(UIColor.lightBlue().colorWithAlphaComponent(0.5), forState: .Highlighted)
        payWithCardButton.titleLabel?.font = UIFont.systemFontOfSize(16, weight: UIFontWeightLight)
        payWithCardButton.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.5)
        payWithCardButton.borderSize = 1
        payWithCardButton.setTitle("Credit Card", forState: .Normal)
        payWithCardButton.clipsToBounds = true
        payWithCardButton.addTarget(self, action: #selector(ChargeViewController.payWithCard(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        Timeout(0.1) {
            addSubviewWithBounce(payWithCardButton, parentView: self, duration: 0.3)
        }
        
        // Pay with card button
        let payWithAlipaybutton = DKCircleButton(frame: CGRect(x: screenWidth/2+10, y: 40+20+screenWidth/2-20-10, width: screenWidth/2-20-10, height: screenWidth/2-20-10))
        payWithAlipaybutton.setBackgroundColor(UIColor.clearColor(), forState: .Normal)
        payWithAlipaybutton.setBackgroundColor(UIColor.clearColor(), forState: .Highlighted)
        payWithAlipaybutton.tintColor = UIColor.lightBlue()
        payWithAlipaybutton.setTitleColor(UIColor.lightBlue(), forState: .Normal)
        payWithAlipaybutton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        payWithAlipaybutton.titleLabel?.font = UIFont.systemFontOfSize(16, weight: UIFontWeightLight)
        payWithAlipaybutton.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.3)
        payWithAlipaybutton.borderSize = 1
        payWithAlipaybutton.setTitle("Alipay \n(coming soon)", forState: .Normal)
        payWithAlipaybutton.clipsToBounds = true
        payWithAlipaybutton.addTarget(self, action: #selector(self.payWithAlipay(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        Timeout(0.3) {
            addSubviewWithBounce(payWithAlipaybutton, parentView: self, duration: 0.3)
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func payWithAlipay(sender: AnyObject) {
        print("alipay selected")
        modalDelegate?.modalViewControllerDismiss(interactive: false, callbackData: ["option":"alipay"])
    }
    
    func payWithBitcoin(sender: AnyObject) {
        print("bitcoin selected")
        modalDelegate?.modalViewControllerDismiss(interactive: false, callbackData: ["option":"bitcoin"])
    }
    
    func payWithCard(sender: AnyObject) {
        print("card selected")
        modalDelegate?.modalViewControllerDismiss(interactive: false, callbackData: ["option":"card"])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func panDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Began :
            guard sender.translationInView(view).y < 0 else {
                break
            }
            modalDelegate?.modalViewControllerDismiss(interactive: true, callbackData: nil)
        default : break
        }
    }
    
    deinit {
        print("Modal deinit.")
    }
    
}
