//
//  ChargeSuccessModalViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 6/4/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit
import TransitionTreasury
import Crashlytics

class ChargePaymentSelectionViewController: UIViewController {
    
    weak var modalDelegate: ModalViewControllerDelegate?
    
    let swipeArrowImageView = UIImageView()

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
        
        swipeArrowImageView.image = UIImage(named: "ic_arrow_up_gray")
        swipeArrowImageView.frame = CGRect(x: 0, y: screenHeight-55, width: screenWidth, height: 20) // shimmeringView.bounds
        swipeArrowImageView.contentMode = .ScaleAspectFit
        addSubviewWithFade(swipeArrowImageView, parentView: self, duration: 1)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissModal(_:)))
        swipeArrowImageView.addGestureRecognizer(tap)
        
        // pay with card
        let payWithCardImageView = UIImageView()
        payWithCardImageView.backgroundColor = UIColor.whiteColor()
        payWithCardImageView.layer.cornerRadius = 10
        payWithCardImageView.frame = CGRect(x: 35, y: screenHeight*0.1, width: screenWidth-70, height: 120)
        payWithCardImageView.contentMode = .ScaleAspectFit
        addSubviewWithShadow(UIColor.lightBlue(), radius: 10.0, offsetX: 0.0, offsetY: 0, opacity: 0.2, parentView: self, childView: payWithCardImageView)
        let payWithCardButton = UIButton()
        let str1 = NSAttributedString(string: "  Credit Card", attributes: [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "ArialRoundedMTBold", size: 18)!
            ])
        payWithCardButton.setAttributedTitle(str1, forState: .Normal)
        payWithCardButton.setBackgroundColor(UIColor.iosBlue(), forState: .Normal)
        payWithCardButton.setBackgroundColor(UIColor.iosBlue().darkerColor(), forState: .Highlighted)
        payWithCardButton.frame = CGRect(x: 35, y: screenHeight*0.1, width: screenWidth-70, height: 120)
        payWithCardButton.setImage(UIImage(named: "LogoCard"), forState: .Normal)
        payWithCardButton.setImage(UIImage(named: "LogoCard")?.alpha(0.5), forState: .Highlighted)
        payWithCardButton.layer.cornerRadius = 10
        payWithCardButton.layer.masksToBounds = true
        payWithCardButton.backgroundColor = UIColor.iosBlue()
        payWithCardButton.addTarget(self, action: #selector(self.payWithCard(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(payWithCardButton)
        self.view.bringSubviewToFront(payWithCardButton)
        self.view.superview?.bringSubviewToFront(payWithCardButton)
        self.view.bringSubviewToFront(payWithCardButton)
        
        let payWithBitcoinImageView = UIImageView()
        payWithBitcoinImageView.backgroundColor = UIColor.whiteColor()
        payWithBitcoinImageView.layer.cornerRadius = 10
        payWithBitcoinImageView.frame = CGRect(x: 35, y: screenHeight*0.32, width: screenWidth-70, height: 120)
        payWithBitcoinImageView.contentMode = .ScaleAspectFit
        addSubviewWithShadow(UIColor.lightBlue(), radius: 10.0, offsetX: 0.0, offsetY: 0, opacity: 0.2, parentView: self, childView: payWithBitcoinImageView)
        let payWithBitcoinButton = UIButton()
        let str2 = NSAttributedString(string: "  Bitcoin", attributes: [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "ArialRoundedMTBold", size: 18)!
            ])
        payWithBitcoinButton.setAttributedTitle(str2, forState: .Normal)
        payWithBitcoinButton.setBackgroundColor(UIColor.bitcoinOrange(), forState: .Normal)
        payWithBitcoinButton.setBackgroundColor(UIColor.bitcoinOrange().darkerColor(), forState: .Highlighted)
        payWithBitcoinButton.frame = CGRect(x: 35, y: screenHeight*0.32, width: screenWidth-70, height: 120)
        payWithBitcoinButton.setImage(UIImage(named: "LogoBitcoin"), forState: .Normal)
        payWithBitcoinButton.setImage(UIImage(named: "LogoBitcoin")?.alpha(0.5), forState: .Highlighted)
        payWithBitcoinButton.layer.cornerRadius = 10
        payWithBitcoinButton.layer.masksToBounds = true
        payWithBitcoinButton.backgroundColor = UIColor.whiteColor()
        payWithBitcoinButton.addTarget(self, action: #selector(self.payWithBitcoin(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(payWithBitcoinButton)
        self.view.bringSubviewToFront(payWithBitcoinButton)
        self.view.superview?.bringSubviewToFront(payWithBitcoinButton)
        self.view.bringSubviewToFront(payWithBitcoinButton)
        
        
        let payWithAlipayImageView = UIImageView()
        payWithAlipayImageView.backgroundColor = UIColor.whiteColor()
        payWithAlipayImageView.layer.cornerRadius = 10
        payWithAlipayImageView.frame = CGRect(x: 35, y: screenHeight*0.54, width: screenWidth-70, height: 120)
        payWithAlipayImageView.contentMode = .ScaleAspectFit
        addSubviewWithShadow(UIColor.lightBlue(), radius: 10.0, offsetX: 0.0, offsetY: 0, opacity: 0.2, parentView: self, childView: payWithAlipayImageView)
        let payWithAlipayButton = UIButton()
        let str3 = NSAttributedString(string: "  Alipay", attributes: [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "ArialRoundedMTBold", size: 18)!
            ])
        payWithAlipayButton.setAttributedTitle(str3, forState: .Normal)
        payWithAlipayButton.setBackgroundColor(UIColor.alipayBlue(), forState: .Normal)
        payWithAlipayButton.setBackgroundColor(UIColor.alipayBlue().darkerColor(), forState: .Highlighted)
        payWithAlipayButton.setImage(UIImage(named: "LogoAlipay"), forState: .Normal)
        payWithAlipayButton.setImage(UIImage(named: "LogoAlipay")?.alpha(0.5), forState: .Highlighted)
        payWithAlipayButton.frame = CGRect(x: 35, y: screenHeight*0.54, width: screenWidth-70, height: 120)
        payWithAlipayButton.layer.cornerRadius = 10
        payWithAlipayButton.layer.masksToBounds = true
        payWithAlipayButton.backgroundColor = UIColor.whiteColor()
        payWithAlipayButton.addTarget(self, action: #selector(self.payWithAlipay(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(payWithAlipayButton)
        self.view.bringSubviewToFront(payWithAlipayButton)
        self.view.superview?.bringSubviewToFront(payWithAlipayButton)
        self.view.bringSubviewToFront(payWithAlipayButton)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func payWithAlipay(sender: AnyObject) {
        print("alipay selected")
        Answers.logCustomEventWithName("Alipay Payment Method Selected",
                                       customAttributes: nil)
        modalDelegate?.modalViewControllerDismiss(interactive: false, callbackData: ["option":"alipay"])
    }
    
    func payWithBitcoin(sender: AnyObject) {
        print("bitcoin selected")
        Answers.logCustomEventWithName("Bitcoin Payment Method Selected",
                                       customAttributes: nil)
        modalDelegate?.modalViewControllerDismiss(interactive: false, callbackData: ["option":"bitcoin"])
    }
    
    func payWithCard(sender: AnyObject) {
        print("card selected")
        Answers.logCustomEventWithName("Credit Card Payment Method Selected",
                                       customAttributes: nil)
        modalDelegate?.modalViewControllerDismiss(interactive: false, callbackData: ["option":"card"])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissModal(sender: AnyObject) {
        modalDelegate?.modalViewControllerDismiss(interactive: true, callbackData: ["option":"none"])
    }
    
    func panDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Began :
            guard sender.velocityInView(view).y < 0 else {
                break
            }
            modalDelegate?.modalViewControllerDismiss(interactive: true, callbackData: ["option":"none"])
        default : break
        }
    }
    
    deinit {
        print("Modal deinit.")
    }
    
}
