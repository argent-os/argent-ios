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
import MZFormSheetPresentationController
import QRCode
import CWStatusBarNotification
import SwiftyJSON
import Alamofire
import TransitionTreasury
import TransitionAnimation
import Shimmer
import Crashlytics
import TRCurrencyTextField

class ChargeViewController: UIViewController, STPPaymentCardTextFieldDelegate, UITextFieldDelegate, UINavigationBarDelegate, ModalTransitionDelegate {
    
    let navigationBar = UINavigationBar()
    
    var tr_presentTransition: TRViewControllerTransitionDelegate?

    let chargeInputView = TRCurrencyTextField()

    let currencyFormatter = NSNumberFormatter()
    
    var paymentTextField = STPPaymentCardTextField()
    
    let notification = CWStatusBarNotification()

    let payButton = UIButton()

    let swipePaymentSelectionLabel = UILabel()

    let swipeArrowImageView = UIImageView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupNav()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    
    //Changing Status Bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    private func setupNav() {
         // Offset by 20 pixels vertically to take the status bar into account
        navigationBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 50)
        navigationBar.backgroundColor = UIColor.clearColor()
        navigationBar.tintColor = UIColor.whiteColor()
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
    
    func addScanCardButton() {
        // Create left and right button for navigation item
        let leftButton = UIBarButtonItem(image: UIImage(named: "IconClose"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ChargeViewController.returnToMenu(_:)))
        let font = UIFont(name: "DINAlternate-Bold", size: 14)
        leftButton.setTitleTextAttributes([NSFontAttributeName: font!, NSForegroundColorAttributeName:UIColor.mediumBlue()], forState: UIControlState.Normal)
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
        
        // Assign the navigation item to the navigation bar
        navigationBar.titleTextAttributes = [NSFontAttributeName: font!, NSForegroundColorAttributeName:UIColor.lightBlue()]
        
        // Create left and right button for navigation item
        let rightButton = UIBarButtonItem(image: UIImage(named: "IconScanCamera"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.scanCard(_:)))
        rightButton.setTitleTextAttributes([NSFontAttributeName: font!, NSForegroundColorAttributeName:UIColor.mediumBlue()], forState: UIControlState.Normal)
        // Create two buttons for the navigation item
        navigationItem.rightBarButtonItem = rightButton
        
        // Assign the navigation item to the navigation bar
        navigationBar.titleTextAttributes = [NSFontAttributeName: font!, NSForegroundColorAttributeName:UIColor.lightBlue()]
        navigationBar.items = [navigationItem]
    }
    
    func configure() {
        
        chargeInputView.becomeFirstResponder()
        let countryCode = NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as! String
        chargeInputView.setCountryCode(countryCode)
        chargeInputView.setLocale(NSLocale.currentLocale())
        chargeInputView.addWhiteSpaceOnSymbol = false
        
        // set up pan gesture recognizers tt
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
        headerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 100)
        self.view.addSubview(headerView)
        self.view.sendSubviewToBack(headerView)
        
        // addDoneToolbar()
        
//        chargeInputView.addTarget(self, action: #selector(self.textField(_:shouldChangeCharactersInRange:replacementString:)), forControlEvents: UIControlEvents.EditingChanged)
        chargeInputView.clearButtonMode = .Never
        chargeInputView.borderStyle = .None
        chargeInputView.frame = CGRect(x: 0, y: 60, width: screenWidth, height: 100)
        chargeInputView.textAlignment = .Center
        chargeInputView.font = UIFont(name: "MyriadPro-Regular", size: 48)!
        chargeInputView.textColor = UIColor.whiteColor()
        chargeInputView.placeholder = "$0.00"
        chargeInputView.maxDigits = 5
        chargeInputView.keyboardType = UIKeyboardType.NumberPad
        chargeInputView.backgroundColor = UIColor.clearColor()
        chargeInputView.tintColor = UIColor.whiteColor()
        let _ = Timeout(0.2) {
            addSubviewWithBounce(self.chargeInputView, parentView: self, duration: 0.3)
        }
        
        let shimmeringView: FBShimmeringView = FBShimmeringView()
        swipePaymentSelectionLabel.text = "Swipe down to select payment option"
        swipePaymentSelectionLabel.textAlignment = .Center
        swipePaymentSelectionLabel.textColor = UIColor.lightBlue()
        swipePaymentSelectionLabel.font = UIFont(name: "MyriadPro-Regular", size: 14)!
        swipePaymentSelectionLabel.frame = CGRect(x: 0, y: 280, width: screenWidth, height: 460) // shimmeringView.bounds

        shimmeringView.frame = CGRect(x: 0, y: 280, width: screenWidth, height: 460) // shimmeringView.bounds
        shimmeringView.contentView = swipePaymentSelectionLabel
        shimmeringView.shimmering = true
        addSubviewWithFade(shimmeringView, parentView: self, duration: 1)
        addSubviewWithFade(swipePaymentSelectionLabel, parentView: self, duration: 1)
        
        swipeArrowImageView.image = UIImage(named: "ic_arrow_down_gray")
        swipeArrowImageView.frame = CGRect(x: 0, y: 255, width: screenWidth, height: 25) // shimmeringView.bounds
        swipeArrowImageView.contentMode = .ScaleAspectFit
        addSubviewWithFade(swipeArrowImageView, parentView: self, duration: 1)
        
        // Pay button
        payButton.frame = CGRect(x: 0, y: screenHeight-60, width: screenWidth, height: 60.0)
        payButton.setBackgroundColor(UIColor.skyBlue(), forState: .Normal)
        payButton.setBackgroundColor(UIColor.skyBlue().lighterColor(), forState: .Highlighted)
        payButton.tintColor = UIColor(rgba: "#fff")
        payButton.setTitleColor(UIColor(rgba: "#fff"), forState: .Normal)
        payButton.setTitleColor(UIColor(rgba: "#fffe"), forState: .Highlighted)
        payButton.titleLabel?.font = UIFont(name: "MyriadPro-Regular", size: 16)!
        payButton.setTitle("Pay Merchant", forState: .Normal)
        payButton.layer.cornerRadius = 0
        payButton.layer.masksToBounds = true
        payButton.clipsToBounds = true
        payButton.addTarget(self, action: #selector(ChargeViewController.save(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        //addSubviewWithFade(self.payButton, parentView: self, duration: 1)

        currencyFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        currencyFormatter.currencyCode = NSLocale.currentLocale().displayNameForKey(NSLocaleCurrencySymbol, value: NSLocaleCurrencyCode)
    }
    
    func interactiveTransition(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Began:
            guard sender.velocityInView(view).y > 0 else {
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
        
        let option = data!["option"]
        let _ = option.map { (unwrappedOption) -> Void in
            // print(unwrappedOption)
            if unwrappedOption as! String == "bitcoin" {
                swipePaymentSelectionLabel.text = "Use any Bitcoin wallet to send BTC"
                swipeArrowImageView.image = UIImage(named: "LogoBitcoinDark")
                paymentTextField.removeFromSuperview()
                self.payButton.removeFromSuperview()
                self.payWithBitcoin(self)
            } else if unwrappedOption as! String == "card" {
                swipePaymentSelectionLabel.text = "Enter credit card information"
                swipeArrowImageView.image = paymentTextField.brandImage
                swipeArrowImageView.alpha = 0.5
                addSubviewWithFade(self.payButton, parentView: self, duration: 1)
                addScanCardButton()
                self.payWithCard(self)
            } else if unwrappedOption as! String == "alipay" {
                swipePaymentSelectionLabel.text = "Swipe down to select payment option"
                swipeArrowImageView.image = UIImage(named: "ic_arrow_down_gray")
                paymentTextField.removeFromSuperview()
                self.payButton.removeFromSuperview()
                showAlert(.Info, title: "Notice", msg: "Alipay is currently not supported!  But we are working on adding it soon")
            } else if unwrappedOption as! String == "none" {
                swipePaymentSelectionLabel.text = "Swipe down to select payment option"
                swipeArrowImageView.image = UIImage(named: "ic_arrow_down_gray")
            }
        }
    }
    
    func paymentCardTextFieldDidChange(textField: STPPaymentCardTextField) {
        // print(paymentTextField.brandImage)
        swipeArrowImageView.alpha = 1
        swipeArrowImageView.image = paymentTextField.brandImage
        if(paymentTextField.isValid) {
            paymentTextField.endEditing(true)
            swipePaymentSelectionLabel.text = "Submit payment"
        }
    }
    
    // STRIPE SAVE METHOD
    @IBAction func save(sender: UIButton) {
        payButton.userInteractionEnabled = false
        addActivityIndicatorButton(UIActivityIndicatorView(), button: payButton, color: .White)
        
        // print("save called")
        // print(chargeInputView.text)
        
        if chargeInputView.text != "" || chargeInputView.text == "$0.00"  {
        showGlobalNotification("Paying merchant " + chargeInputView.text!, duration: 1.5, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.skyBlue())
        } else {
            showGlobalNotification("Amount cannot be empty", duration: 3.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.StatusBarNotification, color: UIColor.neonOrange())
                payButton.userInteractionEnabled = true
        }
        
        if(chargeInputView.text != "" || chargeInputView.text != "$0.00") {
            // print("civ passes check")
            if let card = paymentTextField.card {
                // print("got card")
                STPAPIClient.sharedClient().createTokenWithCard(card) { (token, error) -> Void in
                    if let error = error  {
                        self.payButton.userInteractionEnabled = true
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
            // print("calling create charge")
            let value = Int(Float(chargeInputView.value)*100)
            print(value)
            createCharge(token, amount: value)
        }
    }
    
    func createCharge(token: STPToken, amount: Int) {
        
        User.getProfile { (user, NSError) in
            
            let url = API_URL + "/stripe/" + (user?.id)! + "/charge/"
            
            let parameters : [String : AnyObject] = [
                "token": String(token) ?? "",
                "amount": amount
            ]
            
            let uat = userAccessToken
            let _ = uat.map { (unwrapped_access_token) -> Void in
                let headers = [
                    "Authorization": "Bearer " + String(unwrapped_access_token),
                    "Content-Type": "application/json"
                ]
                
                // for invalid character 0 be sure the content type is application/json and enconding is .JSON
                Alamofire.request(.POST, url,
                    parameters: parameters,
                    encoding:.JSON,
                    headers: headers)
                    .responseJSON { response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            // let json = JSON(value)
                            //print(json)
                            print(PKPaymentAuthorizationStatus.Success)
                            self.showPersonalInformationModal(self, amount: 0)
                            self.payButton.userInteractionEnabled = true
                            self.paymentTextField.clear()
                            showAlert(.Success, title: "Success", msg: "Payment for " + self.chargeInputView.text! + " succeeded!")
                            var str = self.chargeInputView.text
                            str?.removeAtIndex(str!.characters.indices.first!) // remove first letter
                            Answers.logPurchaseWithPrice(decimalWithString(self.currencyFormatter, string: str!),
                                currency: "USD",
                                success: true,
                                itemName: "Payment",
                                itemType: "POS Sale",
                                itemId: "sku-###",
                                customAttributes: nil)
                            self.swipeArrowImageView.image = UIImage(named: "ic_arrow_down_gray")
                            self.swipePaymentSelectionLabel.text = "Swipe down to select payment option"
                            self.chargeInputView.text = ""
                        }
                    case .Failure(let error):
                        print(PKPaymentAuthorizationStatus.Failure)
                        self.payButton.userInteractionEnabled = true
                        Answers.logCustomEventWithName("CRITICAL: ERROR PAYING MERCHANT",
                            customAttributes: [
                                "error": error.localizedDescription
                            ])
                        showGlobalNotification("Error paying merchant", duration: 5.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.StatusBarNotification, color: UIColor.neonOrange())
                        self.paymentTextField.clear()

                        print(error)
                    }
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
        paymentTextField.frame = CGRectMake(-15, 300, screenWidth+15, 80)
        paymentTextField.textColor = UIColor.lightBlue()
        paymentTextField.textErrorColor = UIColor.brandRed()
        paymentTextField.placeholderColor = UIColor.lightBlue().colorWithAlphaComponent(0.3)
        paymentTextField.contentVerticalAlignment = .Center
        paymentTextField.delegate = self
        paymentTextField.borderWidth = 1
        paymentTextField.borderColor = UIColor.offWhite()
        paymentTextField.layer.cornerRadius = 0
        // adds a manual credit card entry textfield
        addSubviewWithBounce(paymentTextField, parentView: self, duration: 0.3)
        paymentTextField.becomeFirstResponder()
        
        let maskCardImageView = UIView()
        maskCardImageView.backgroundColor = UIColor.whiteColor()
        maskCardImageView.frame = CGRectMake(0, 320, 30, 35)
        self.view.addSubview(maskCardImageView)
    }
    
    func returnToMenu(sender: AnyObject) {
        self.view.window!.rootViewController!.dismissViewControllerAnimated(true, completion: { _ in })
    }

    func reset() {
        // this'll run if cancel is pressed after the alert is dismissed
        paymentTextField.removeFromSuperview()
        chargeInputView.text = ""
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
            return ges.velocityInView(ges.view).y != 0
        }
        return false
    }
}

extension ChargeViewController: CardIOPaymentViewControllerDelegate {
    // CARD IO
    @IBAction func scanCard(sender: AnyObject) {
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC.hideCardIOLogo = true
        cardIOVC.collectPostalCode = true
        cardIOVC.allowFreelyRotatingCardGuide = true
        cardIOVC.guideColor = UIColor.skyBlue()
        cardIOVC.modalPresentationStyle = .FormSheet
        presentViewController(cardIOVC, animated: true, completion: nil)
    }
    
    func userDidCancelPaymentViewController(paymentViewController: CardIOPaymentViewController!) {
        //        resultLabel.text = "Card not entered"
        paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didScanCard(cardInfo: CardIOCreditCardInfo) {
        // The full card number is available as info.cardNumber, but don't log that!
        // print("Received card info. Number: %@, expiry: %02i/%i, cvv: %@.", cardInfo.redactedCardNumber, cardInfo.expiryMonth, cardInfo.expiryYear, cardInfo.cvv);
        // Use the card info...
        // Post to Stripe, make API call here
    }
    
    func userDidProvideCreditCardInfo(cardInfo: CardIOCreditCardInfo!, inPaymentViewController paymentViewController: CardIOPaymentViewController!) {
        if let info = cardInfo {
            let card: STPCardParams = STPCardParams()
            card.number = info.cardNumber
            card.expMonth = info.expiryMonth
            card.expYear = info.expiryYear
            card.cvc = info.cvv
            paymentTextField.cardParams = card
            swipePaymentSelectionLabel.text = "Submit payment"
            let _ = Timeout(0.2) {
                self.paymentTextField.endEditing(true)
            }
        }
        paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension ChargeViewController {
    
    // Bitcoin extensions
    
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
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewControllerWithIdentifier("qrFormSheetController") as! UINavigationController
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
        formSheetController.presentationController?.movementActionWhenKeyboardAppears = MZFormSheetActionWhenKeyboardAppears.CenterVertically
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
}


extension ChargeViewController {
    
    // MARK: Personal Information receipt modal
    
    func showPersonalInformationModal(sender: AnyObject, amount: Int) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewControllerWithIdentifier("personalInformationEntryModalNavigationController") as! UINavigationController
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        
        // Initialize and style the terms and conditions modal
        formSheetController.presentationController?.shouldApplyBackgroundBlurEffect = true
        formSheetController.presentationController?.contentViewSize = CGSizeMake(280, 200)
        formSheetController.presentationController?.shouldUseMotionEffect = true
        formSheetController.presentationController?.containerView?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        formSheetController.presentationController?.containerView?.sizeToFit()
        formSheetController.presentationController?.blurEffectStyle = UIBlurEffectStyle.Dark
        formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
        formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle.SlideFromBottom
        formSheetController.presentationController?.movementActionWhenKeyboardAppears = MZFormSheetActionWhenKeyboardAppears.CenterVertically
        formSheetController.contentViewCornerRadius = 10
        formSheetController.allowDismissByPanningPresentedView = true
        formSheetController.interactivePanGestureDismissalDirection = .All;
        
        // Blur will be applied to all MZFormSheetPresentationControllers by default
        MZFormSheetPresentationController.appearance().shouldApplyBackgroundBlurEffect = true
        
        let presentedViewController = navigationController.viewControllers.first as! PersonInformationEntryModalViewController
        
        // keep passing along user data to modal
        presentedViewController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        presentedViewController.navigationItem.leftItemsSupplementBackButton = true
        
        presentedViewController.receiptAmount = chargeInputView.text
        self.presentViewController(formSheetController, animated: true, completion: nil)

    }
}