//
//  ChargeViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/3/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit
import Foundation
import Stripe
import JSSAlertView
import MZFormSheetPresentationController
import QRCode
import CWStatusBarNotification
import SwiftyJSON
import Alamofire
import TransitionTreasury
import TransitionAnimation
import Shimmer

class ChargeViewController: UIViewController, STPPaymentCardTextFieldDelegate, UITextFieldDelegate, UINavigationBarDelegate, ModalTransitionDelegate {
    
    var tr_presentTransition: TRViewControllerTransitionDelegate?

    let chargeInputView = UITextField()

    let currencyFormatter = NSNumberFormatter()
    
    var paymentTextField = STPPaymentCardTextField()
    
    let notification = CWStatusBarNotification()

    let payButton = UIButton()

    func textFieldDidChange(textField: UITextField) {
        let text = textField.text!.stringByReplacingOccurrencesOfString(currencyFormatter.currencySymbol, withString: "").stringByReplacingOccurrencesOfString(currencyFormatter.groupingSeparator, withString: "").stringByReplacingOccurrencesOfString(currencyFormatter.decimalSeparator, withString: "")
        // textField.attributedText = formatCurrency(text, fontName: "HelveticaNeue-Light", superSize: 24, fontSize: 48, offsetSymbol: 12, offsetCents: 12)
        textField.text = currencyFormatter.stringFromNumber((text as NSString).doubleValue / 100.0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupNav()
    }
    
    override func viewDidAppear(animated: Bool) {
        chargeInputView.becomeFirstResponder()
        super.viewDidAppear(true)
    }
    
    //Changing Status Bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    private func setupNav() {
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 50)) // Offset by 20 pixels vertically to take the status bar into account
        
        navigationBar.backgroundColor = UIColor.clearColor()
        navigationBar.tintColor = UIColor.lightBlue()
        navigationBar.delegate = self
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = ""
        
        // Create left and right button for navigation item
        let leftButton = UIBarButtonItem(image: UIImage(named: "IconClose"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ChargeViewController.returnToMenu(_:)))
        let font = UIFont(name: "DINAlternate-Bold", size: 14)
        leftButton.setTitleTextAttributes([NSFontAttributeName: font!, NSForegroundColorAttributeName:UIColor.mediumBlue()], forState: UIControlState.Normal)
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
        
        // Assign the navigation item to the navigation bar
        navigationBar.titleTextAttributes = [NSFontAttributeName: font!, NSForegroundColorAttributeName:UIColor.lightBlue()]
        navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
    }
    
    func configure() {
        
        // set up pan gesture recognizers
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.interactiveTransition(_:)))
        pan.delegate = self
        view.addGestureRecognizer(pan)
        
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        self.view.frame = CGRect(x: 0, y: 80, width: screenWidth, height: screenHeight)
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.layer.shadowOffset = CGSizeMake(0, 0)
        self.view.layer.shadowColor = UIColor.clearColor().CGColor
        self.view.layer.cornerRadius = 0.0
        self.view.layer.shadowRadius = 0.0
        self.view.layer.shadowOpacity = 0.00
        
        let headerView = UIImageView()
        headerView.image = UIImage(named: "BackgroundSwipeDown")
        headerView.contentMode = .ScaleAspectFill
        headerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 200)
        self.view.addSubview(headerView)
        self.view.sendSubviewToBack(headerView)
        
        let contentView = UIView()
        self.view.addSubview(contentView)
        
        // addDoneToolbar()
        
        chargeInputView.addTarget(self, action: #selector(ChargeViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        chargeInputView.frame = CGRect(x: 0, y: 60, width: screenWidth, height: 100)
        chargeInputView.textAlignment = .Center
        chargeInputView.font = UIFont.systemFontOfSize(48, weight: UIFontWeightLight)
        chargeInputView.textColor = UIColor.lightBlue()
        chargeInputView.placeholder = "$0.00"
        chargeInputView.keyboardType = UIKeyboardType.NumberPad
        chargeInputView.backgroundColor = UIColor.clearColor()
        Timeout(0.2) {
            addSubviewWithBounce(self.chargeInputView, parentView: self, duration: 0.3)
        }
        
        let shimmeringView: FBShimmeringView = FBShimmeringView(frame: self.view.bounds)
        let swipePaymentSelectionLabel = UILabel()
        swipePaymentSelectionLabel.text = "Swipe down to select payment option"
        swipePaymentSelectionLabel.frame = CGRect(x: 0, y: 200, width: screenWidth, height: 120) // shimmeringView.bounds
        swipePaymentSelectionLabel.textAlignment = .Center
        swipePaymentSelectionLabel.textColor = UIColor.lightBlue()
        swipePaymentSelectionLabel.font = UIFont.systemFontOfSize(18, weight: UIFontWeightThin)
        self.view!.addSubview(shimmeringView)
        shimmeringView.contentView = swipePaymentSelectionLabel
        shimmeringView.shimmering = true

        addSubviewWithFade(swipePaymentSelectionLabel, parentView: self, duration: 1)
        
        // Pay button
        payButton.frame = CGRect(x: 0, y: screenHeight-80, width: screenWidth, height: 80.0)
        payButton.setBackgroundColor(UIColor.lightBlue(), forState: .Normal)
        payButton.setBackgroundColor(UIColor.lightBlue().colorWithAlphaComponent(0.75), forState: .Highlighted)
        payButton.tintColor = UIColor(rgba: "#fff")
        payButton.setTitleColor(UIColor(rgba: "#fff"), forState: .Normal)
        payButton.setTitleColor(UIColor(rgba: "#fffe"), forState: .Highlighted)
        payButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        payButton.setTitle("Pay Merchant", forState: .Normal)
        payButton.layer.cornerRadius = 0
        payButton.layer.masksToBounds = true
        payButton.clipsToBounds = true
        payButton.addTarget(self, action: #selector(ChargeViewController.save(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        Timeout(0.6) {
            addSubviewWithFade(self.payButton, parentView: self, duration: 1)
        }
        
        currencyFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        currencyFormatter.currencyCode = NSLocale.currentLocale().displayNameForKey(NSLocaleCurrencySymbol, value: NSLocaleCurrencyCode)
    }

    func interactiveTransition(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Began:
            guard sender.translationInView(view).y > 0 else {
                break
            }
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ChargePaymentSelectionViewController") as! ChargePaymentSelectionViewController
            vc.modalDelegate = self
            tr_presentViewController(vc, method: TRPresentTransitionMethod.Scanbot(present: sender, dismiss: vc.dismissGestureRecognizer), completion: {
                print("Present finished")
            })
        default: break
        }
    }
    
    // modal callback
    func modalViewControllerDismiss(interactive interactive: Bool, callbackData data: AnyObject?) {
        
        tr_dismissViewController(interactive: interactive, completion: nil)
        print("got callback data")
        print(data)
    }
    
    // STRIPE SAVE METHOD
    @IBAction func save(sender: UIButton) {
        payButton.userInteractionEnabled = false
        addActivityIndicatorButton(UIActivityIndicatorView(), button: payButton, color: .White)
        
        // print("save called")
        // print(chargeInputView.text)
        showGlobalNotification("Paying merchant " + chargeInputView.text!, duration: 1.5, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.skyBlue())

        if(chargeInputView.text != "" || chargeInputView.text != "$0.00") {
            // print("civ passes check")
            if let card = paymentTextField.card {
                // print("got card")
                STPAPIClient.sharedClient().createTokenWithCard(card) { (token, error) -> Void in
                    if let error = error  {
                        print(error)
                    }
                    else if let token = token {
                        print("got token")
                        self.createBackendChargeWithToken(token) { status in
                            // print(status)
                        }
                    }
                }
            }
        } else {
            print("failed")
            payButton.userInteractionEnabled = true
            showGlobalNotification("Invalid Amount" + chargeInputView.text!, duration: 5.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.neonOrange())
        }
    }
    
    func createBackendChargeWithToken(token: STPToken!, completion: PKPaymentAuthorizationStatus -> ()) {
        // SEND REQUEST TO API ENDPOINT TO EXCHANGE STRIPE TOKEN

        // print("creating backend charge with token")
        if(chargeInputView.text == "" || chargeInputView.text == "$0.00") {
            showGlobalNotification("Amount invalid", duration: 5.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.StatusBarNotification, color: UIColor.brandRed())
        } else {
            var str = chargeInputView.text
            str?.removeAtIndex(str!.characters.indices.first!) // remove first letter
            let floatValue = (str! as NSString).floatValue
            let amountInCents = Int(floatValue*100)

            // print("calling create charge")
            createCharge(token, amount: amountInCents)
        }
    }
    
    func createCharge(token: STPToken, amount: Int) {
        
        // print("creating backend token")
        User.getProfile { (user, NSError) in
            let url = API_URL + "/v1/stripe/" + (user?.id)! + "/charge/"
            
            let headers = [
                "Authorization": "Bearer " + String(userAccessToken),
                "Content-Type": "application/json"
            ]
            let parameters : [String : AnyObject] = [
                "token": String(token) ?? "",
                "amount": amount
            ]
            
            // print(token)
            
            // for invalid character 0 be sure the content type is application/json and enconding is .JSON
            Alamofire.request(.POST, url,
                parameters: parameters,
                encoding:.JSON,
                headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let json = JSON(value)
                            // print(json)
                            print(PKPaymentAuthorizationStatus.Success)
                            self.payButton.userInteractionEnabled = true
                            self.paymentTextField.clear()
                            self.showAlert("Payment for " + self.chargeInputView.text! + " succeeded!", color: UIColor.skyBlue(), image:UIImage(named: "ic_check_light")!)
                            self.chargeInputView.text == ""
                        }
                    case .Failure(let error):
                        print(PKPaymentAuthorizationStatus.Failure)
                        self.payButton.userInteractionEnabled = true
                        showGlobalNotification("Error paying merchant", duration: 5.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.StatusBarNotification, color: UIColor.neonOrange())
                        self.paymentTextField.clear()

                        print(error)
                    }
            }
        }
    }
    
    func payWithCard(sender: AnyObject) {
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        _ = screen.size.height
        // Card text
        paymentTextField.frame = CGRectMake(20, 260, screenWidth - 40, 60)
        paymentTextField.delegate = self
        paymentTextField.borderWidth = 1
        paymentTextField.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.5)
        paymentTextField.layer.cornerRadius = 10
        // adds a manual credit card entry textfield
        addSubviewWithBounce(paymentTextField, parentView: self, duration: 0.3)
        paymentTextField.becomeFirstResponder()
    }
    
    func getCurrentBitcoinValue(completionHandler: (value: Float) -> Void) {
        Alamofire.request(.GET, "https://blockchain.info/ticker", parameters: [:], encoding: .JSON, headers: [:])
        .validate()
        .responseJSON { (response) in
        switch response.result {
            case .Success:
                if let value = response.result.value {
                    let data = JSON(value)
                    let bitcoinUSDValue = data["USD"]["15m"].floatValue
                    // print("1 bitcoin is currently worth ")
                    // print("$", bitcoinUSDValue)
                    completionHandler(value: bitcoinUSDValue)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func payWithBitcoin(sender: AnyObject) {
        addActivityIndicatorView(UIActivityIndicatorView(), view: self.view, color: .Gray)
        
        let navigationController = self.storyboard!.instantiateViewControllerWithIdentifier("qrFormSheetController") as! UINavigationController
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        
        self.view.endEditing(true)
        
        // Initialize and style the terms and conditions modal
        formSheetController.presentationController?.shouldApplyBackgroundBlurEffect = true
        formSheetController.presentationController?.contentViewSize = CGSizeMake(250, 300)
        formSheetController.presentationController?.shouldUseMotionEffect = true
        formSheetController.presentationController?.containerView?.backgroundColor = UIColor.blackColor()
        formSheetController.presentationController?.containerView?.sizeToFit()
        formSheetController.presentationController?.blurEffectStyle = UIBlurEffectStyle.Dark
        formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
        formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle.SlideFromBottom
        formSheetController.contentViewCornerRadius = 10
        formSheetController.allowDismissByPanningPresentedView = true
        formSheetController.interactivePanGestureDismissalDirection = .All;
        
        // Blur will be applied to all MZFormSheetPresentationControllers by default
        MZFormSheetPresentationController.appearance().shouldApplyBackgroundBlurEffect = true
        
        let presentedViewController = navigationController.viewControllers.first as! BitcoinUriViewController
        // get bitcoin receiver through api call, put url in response below
        
        if chargeInputView.text != "" {
            var str = chargeInputView.text
            str?.removeAtIndex(str!.characters.indices.first!) // remove first letter

            let floatValue = (str! as NSString).floatValue*100
            
            Bitcoin.createBitcoinReceiver(Int(floatValue)) { (bitcoin, err) in
                
                    presentedViewController.bitcoinUri = bitcoin?.uri ?? ""
                    presentedViewController.bitcoinId = bitcoin?.id ?? ""
                    presentedViewController.bitcoinFilled = bitcoin?.filled ?? false
                    presentedViewController.bitcoinAmount = bitcoin?.amount ?? 0
                
                    formSheetController.willPresentContentViewControllerHandler = { vc in
                        let navigationController = vc as! UINavigationController
                        let presentedViewController = navigationController.viewControllers.first as! BitcoinUriViewController
                        presentedViewController.view?.layoutIfNeeded()
                    }
                    
                    self.presentViewController(formSheetController, animated: true, completion: nil)
                }
            }
 
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selectCustomerView" {
        }
        if(segue.identifier == "mainMenuView") {
            let rootViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("RootViewController"))! as UIViewController
            self.presentViewController(rootViewController, animated: true, completion: nil)
        }
    }
    
    // Add send toolbar
    func addDoneToolbar() {
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        _ = screen.size.height
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, screenWidth, 60))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(ChargeViewController.dismissKeyboard(_:)))
        done.tintColor = UIColor.whiteColor()
        UIToolbar.appearance().barTintColor = UIColor.lightBlue()
        done.setTitleTextAttributes([
            NSFontAttributeName : UIFont(name: "DINAlternate-Bold", size: 15)!,
            NSForegroundColorAttributeName : UIColor(rgba: "#fff")
            ], forState: .Normal)
        var items: [UIBarButtonItem]? = [UIBarButtonItem]()
        items?.append(flexSpace)
        items?.append(done)
        items?.append(flexSpace)
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        chargeInputView.inputAccessoryView=doneToolbar
    }
    
    func createCharge(sender: AnyObject) {
        
    }
    
    func returnToMenu(sender: AnyObject) {
        self.view.window!.rootViewController!.dismissViewControllerAnimated(true, completion: { _ in })
    }

    func showAlert(msg: String, color: UIColor, image: UIImage) {
        let customIcon:UIImage = image // your custom icon UIImage
        let customColor:UIColor = color // base color for the alert
        self.view.endEditing(true)
        let alertView = JSSAlertView().show(
            self,
            title: "",
            text: msg,
            buttonText: "Ok",
            noButtons: false,
            color: customColor,
            iconImage: customIcon)
        alertView.setTextTheme(.Light) // can be .Light or .Dark
        alertView.addAction(reset)
    }
    
    func reset() {
        // this'll run if cancel is pressed after the alert is dismissed
        paymentTextField.removeFromSuperview()
        chargeInputView.text = ""
    }
    
    func paymentCardTextFieldDidChange(textField: STPPaymentCardTextField) {
        if(paymentTextField.isValid) {
            paymentTextField.endEditing(true)
        }
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard(sender: AnyObject) {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
        paymentTextField.endEditing(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        dismissKeyboard(self)
        super.viewWillDisappear(animated)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}


extension ChargeViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let ges = gestureRecognizer as? UIPanGestureRecognizer {
            return ges.translationInView(ges.view).y != 0
        }
        return false
    }
}