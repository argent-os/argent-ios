//
//  MerchantPlansViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/27/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import MZFormSheetPresentationController
import XLActionController
import Alamofire
import Stripe
import SwiftyJSON
import DZNEmptyDataSet
import CellAnimator
import AvePurchaseButton
import EmitterKit
import PassKit
import CWStatusBarNotification
import XLActionController
import Crashlytics

class MerchantPlansViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UIGestureRecognizerDelegate {
    
    private var dateFormatter = NSDateFormatter()
    
    private var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    private var merchantLabel:UILabel = UILabel()
    
    private var tableView = UITableView()
    
    private var plansArray:Array<Plan>?
    
    private var cellReuseIdendifier = "idCellMerchantPlan"
    
    private var selectedRow: Int?
    
    private var selectedAmount: Float?
    
    let currencyFormatter = NSNumberFormatter()
    
    var paymentMethod: String = "None"
    
    var paymentSuccessSignal: Signal? = Signal()
    
    var paymentCancelSignal: Signal? = Signal()

    var paymentSuccessListener: Listener?
    
    var paymentCancelListener: Listener?
    
    var globalTag: Int?
    
    var detailUser: User? {
        didSet {
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.childViewControllerForStatusBarStyle()?.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        setupNav()
        
        addInfiniteScroll()
    }
    
    private func addInfiniteScroll() {
        // Add infinite scroll handler
        // change indicator view style to white
        self.tableView.infiniteScrollIndicatorStyle = .Gray
        
        // Add infinite scroll handler
        self.tableView.addInfiniteScrollWithHandler { (scrollView) -> Void in
            let tableView = scrollView as! UITableView
            
            //
            // fetch your data here, can be async operation,
            // just make sure to call finishInfiniteScroll in the end
            //
            if self.plansArray!.count > 98 {
                let lastIndex = NSIndexPath(forRow: self.plansArray!.count - 1, inSection: 0)
                let id = self.plansArray![lastIndex.row].id
                // fetch more data with the id
                self.loadPlans("100", starting_after: id!, completionHandler: { (plans, err) in
                    print(plans)
                })
            }
            
            if self.plansArray!.count == 0 {
                print("plans is less than 1")
                self.loadPlans("100", starting_after: "", completionHandler: { _ in
                    self.tableView.reloadData()
                })
            }
            
            // make sure you reload tableView before calling -finishInfiniteScroll
            tableView.reloadData()
            
            // finish infinite scroll animation
            tableView.finishInfiniteScroll()
        }
    }
    
    func configureView() {
        
        // This will set to only one instance
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.layer.borderWidth = 1
        self.view.layer.masksToBounds = true
        self.view.layer.cornerRadius = 10.0
        self.view.layer.borderColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.2).CGColor
        self.view.layer.borderWidth = 1
        self.view.layer.shadowColor = UIColor.blackColor().CGColor
        self.view.layer.shadowOpacity = 0.8
        self.view.layer.shadowRadius = 3.0
        self.view.layer.shadowOffset = CGSizeMake(2.0, 2.0)
        
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.lightBlue()
        
        tableView.registerClass(MerchantPlanCell.self, forCellReuseIdentifier: cellReuseIdendifier)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = UIColor.paleBlue().colorWithAlphaComponent(0.5)
        tableView.frame = CGRect(x: 0, y: 10, width: 310, height: self.view.frame.height*0.75)
        self.view.addSubview(tableView)
        
        self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        self.dateFormatter.timeStyle = NSDateFormatterStyle.LongStyle
        
        // add gesture recognizer to window
        var recognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MerchantPlansViewController.handleTapBehind(_:)))
        recognizer.numberOfTapsRequired = 1
        recognizer.cancelsTouchesInView = false
        //So the user can still interact with controls in the modal view
        self.view.addGestureRecognizer(recognizer)
        recognizer.delegate = self
        
        self.loadPlans("100", starting_after: "", completionHandler: { _ in })
    }
    
    
    private func setupNav() {
        let navigationBar = self.navigationController?.navigationBar
        
        navigationBar!.backgroundColor = UIColor.offWhite()
        navigationBar!.tintColor = UIColor.darkBlue()
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        
        // Create left and right button for navigation item
        let leftButton = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: #selector(self.close(_:)))
        //        let leftButton = UIBarButtonItem(image: UIImage(named: "IconClose"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.close(_:)))
        let font = UIFont(name: "MyriadPro-Regular", size: 17)!
        leftButton.setTitleTextAttributes([NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor.mediumBlue()], forState: UIControlState.Normal)
        leftButton.setTitleTextAttributes([NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor.darkBlue()], forState: UIControlState.Highlighted)
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton

        let str = ""
        if let bn = detailUser?.business_name where detailUser?.business_name != "" {
            let rightButton = UIBarButtonItem(title: str + bn, style: .Plain, target: self, action: nil)
            rightButton.setTitleTextAttributes([NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor.mediumBlue()], forState: UIControlState.Normal)
            // Create two buttons for the navigation item
            navigationItem.rightBarButtonItem = rightButton
        } else if let fn = detailUser?.first_name, ln = detailUser?.last_name where detailUser?.first_name != "" && detailUser?.last_name != "" {
            let rightButton = UIBarButtonItem(title: str + fn + " " + ln, style: .Plain, target: self, action: nil)
            rightButton.setTitleTextAttributes([NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor.mediumBlue()], forState: UIControlState.Normal)
            // Create two buttons for the navigation item
            navigationItem.rightBarButtonItem = rightButton
        } else if let un = detailUser?.username {
            let rightButton = UIBarButtonItem(title: str + "@" + un + "'s plans", style: .Plain, target: self, action: nil)
            rightButton.setTitleTextAttributes([NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor.mediumBlue()], forState: UIControlState.Normal)
            // Create two buttons for the navigation item
            navigationItem.rightBarButtonItem = rightButton
        } else {
            let rightButton = UIBarButtonItem(title: "Subscription plans", style: .Plain, target: self, action: nil)
            rightButton.setTitleTextAttributes([NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor.mediumBlue()], forState: UIControlState.Normal)
            // Create two buttons for the navigation item
            navigationItem.rightBarButtonItem = rightButton
        }
        
        // Assign the navigation item to the navigation bar
        navigationBar!.titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor.darkGrayColor()]
        navigationBar!.items = [navigationItem]
        
    }
    
    func close(sender: AnyObject) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func handleTapBehind(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            // passing nil gives us coordinates in the window
            let location: CGPoint = sender.locationInView(nil)
            // convert the tap's location into the local view's coordinate system, and test to see if it's in or outside. If outside, dismiss the view.
            if !self.view!.pointInside(self.view!.convertPoint(location, fromView: self.view.window), withEvent: nil) {
                // remove the recognizer first so it's view.window is valid
                self.view.removeGestureRecognizer(sender)
                self.paymentCancelSignal?.emit()
            }
        }
    }
    
    private func loadPlans(limit: String, starting_after: String, completionHandler: ([Plan]?, NSError?) -> ()) {
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        // self.view.addSubview(activityIndicator)
        Plan.getDelegatedPlanList((detailUser?.username)!, limit: limit, starting_after: starting_after, completionHandler: { (plans, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Could not load plans \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            self.plansArray = plans
            self.activityIndicator.stopAnimating()
            
            // sets empty data set if data is nil
            self.tableView.emptyDataSetSource = self
            self.tableView.emptyDataSetDelegate = self
            self.tableView.tableFooterView = UIView()
            self.tableView.reloadData()
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.plansArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdendifier, forIndexPath: indexPath) as! MerchantPlanCell
        
        // CellAnimator.animateCell(cell, withTransform: CellAnimator.TransformTilt, andDuration: 0.3)
        
        if let name = plansArray![indexPath.row].name {
            cell.planNameLabel.text = name
        }
        if let amount = plansArray![indexPath.row].amount, let interval = plansArray![indexPath.row].interval {
            let fcMYR = formatCurrency(amount, fontName: "MyriadPro-Regular", superSize: 11, fontSize: 14, offsetSymbol: 2, offsetCents: 2)
            
            let fcDIN = formatCurrency(amount, fontName: "DINAlternate-Bold", superSize: 11, fontSize: 14, offsetSymbol: 2, offsetCents: 2)
            
            let attrs: [String: AnyObject] = [
                NSForegroundColorAttributeName : UIColor.darkBlue(),
                NSFontAttributeName : UIFont(name: "MyriadPro-Regular", size: 12)!
            ]
            
            let attrs2: [String: AnyObject] = [
                NSForegroundColorAttributeName : UIColor.brandGreen(),
                NSFontAttributeName : UIFont(name: "DINAlternate-Bold", size: 14)!
            ]
            
            cell.planButton.attributedNormalTitle = fcDIN
            cell.planButton.attributedConfirmationTitle = NSAttributedString(string: "Subscribed", attributes: attrs2)
            cell.planButton.addTarget(self, action: #selector(self.purchaseButtonTapped(_:)), forControlEvents: .TouchUpInside)
            cell.planButton.tag = indexPath.row
            
            switch interval {
            case "day":
                let interval = NSAttributedString(string: " per day", attributes: attrs)
                cell.planAmountLabel.attributedText = fcMYR + interval
            case "week":
                let interval = NSAttributedString(string: " per wk", attributes: attrs)
                cell.planAmountLabel.attributedText = fcMYR + interval
            case "month":
                let interval = NSAttributedString(string: " per mo", attributes: attrs)
                cell.planAmountLabel.attributedText = fcMYR + interval
            case "year":
                let interval = NSAttributedString(string: " per yr", attributes: attrs)
                cell.planAmountLabel.attributedText = fcMYR + interval
            default:
                let interval = NSAttributedString(string: " per " + interval, attributes: attrs)
                cell.planAmountLabel.attributedText = fcMYR + interval
            }
        }
        
        return cell
    }
    
    func purchaseButtonTapped(button: AvePurchaseButton) {
        switch button.buttonState {
        case AvePurchaseButtonState.Normal:
            button.setButtonState(AvePurchaseButtonState.Progress, animated: true)
            let tag = button.tag
            globalTag = button.tag
            // with the button tag we have the indexPath of the table, send this into the show pay modal then apple pay modal, then select the index row path based on the button tag
            self.showPayModal(self, tag: tag)
            // print(paymentSuccessListener?.isListening)
            paymentSuccessListener = self.paymentSuccessSignal!.once {
                print("payment success executed")
                button.setButtonState(AvePurchaseButtonState.Normal, animated: true)
                button.setButtonState(AvePurchaseButtonState.Confirmation, animated: true)
                button.attributedNormalTitle = NSAttributedString(string: "Subscribed", attributes: [
                    NSForegroundColorAttributeName : UIColor.brandGreen(),
                    NSFontAttributeName : UIFont(name: "DINAlternate-Bold", size: 14)!
                    ])
            }
            paymentCancelListener = self.paymentCancelSignal!.once {
                print("payment finish executed")
                button.setButtonState(AvePurchaseButtonState.Normal, animated: true)
            }
        case AvePurchaseButtonState.Progress:
            // start the purchasing progress here, when done, go back to AvePurchaseButtonStateProgress
            // listen for completion
            break
        case AvePurchaseButtonState.Confirmation:
            break
        }
    }
    
    func stopAnimation(sender: AnyObject, button: AvePurchaseButton) {
//        ** throws kitchen sink **
//        print("stopping animation")
//        self.paymentCancelSignal?.emit()
//        AvePurchaseButton().setButtonState(AvePurchaseButtonState.Normal, animated: true)
//        paymentCancelListener = self.paymentCancelSignal!.once {
//            print("payment finish executed")
//            button.setButtonState(AvePurchaseButtonState.Normal, animated: true)
//        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.selectedRow = indexPath.row
        self.performSegueWithIdentifier("viewPlanDetail", sender: self)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewPlanDetail" {
            let destination = segue.destinationViewController as! MerchantPlanDetailViewController
            guard let name = plansArray![self.selectedRow!].name else {
                return
            }
            guard let amount = plansArray![self.selectedRow!].amount else {
                return
            }
            guard let interval = plansArray![self.selectedRow!].interval else {
                return
            }
            guard let desc = plansArray![self.selectedRow!].statement_desc else {
                return
            }
            destination.planName = name
            destination.planAmount = amount
            destination.planInterval = interval
            destination.planStatementDescriptor = desc
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // MARK: DZNEmptyDataSet delegate
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = ""
        //let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: headerAttrs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "This user does not have any currently available subscription plans."
        //let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: bodyAttrs)
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "IconEmptyPlans")
    }
    
    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
        let str = ""
        //let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleCallout)]
        return NSAttributedString(string: str, attributes: calloutAttrs)
    }
    
    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RecurringBillingViewController") as! RecurringBillingViewController
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}


extension MerchantPlansViewController: STPPaymentCardTextFieldDelegate, PKPaymentAuthorizationViewControllerDelegate, UITextFieldDelegate {
    
    // MARK: Payment Options Modal
    
    func showPayModal(sender: AnyObject, tag: Int) {
        let actionController = ArgentActionController()
        actionController.headerData = "Subscribe with"
        actionController.addAction(Action("Apple Pay", style: .Default, handler: { action in
            let _ = Timeout(0.5) {
                print("showing apple pay modal")
                self.paymentMethod = "Apple Pay"
                self.showApplePayModal(self, tag: tag)
            }
        }))
        actionController.addAction(Action("Credit or Debit Card", style: .Default, handler: { action in
            let _ = Timeout(0.5) {
                print("showing credit card modal")
                self.paymentMethod = "Credit Card"
                self.showCreditCardModal(self, tag: tag)
            }
        }))
        actionController.addSection(ActionSection())
        actionController.addAction(Action("Cancel", style: .Destructive, handler: { action in
            self.paymentCancelSignal!.emit()
        }))
        
        self.presentViewController(actionController, animated: true, completion: { _ in })
    }

    
    // MARK: APPLE PAY
    
    func showApplePayModal(sender: AnyObject, tag: Int) {
        print("inside show apple pay modal")
        guard let request = Stripe.paymentRequestWithMerchantIdentifier(MERCHANT_ID) else {
            // request will be nil if running on < iOS8
            return
        }
        guard let amount = plansArray![tag].amount else {
            return
        }
        
        let amt = Float(amount)!/100
        
        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: (detailUser?.first_name)!, amount: NSDecimalNumber(float: amt))
        ]
        if PKPaymentAuthorizationViewController.canMakePaymentsUsingNetworks([PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa]) {
            // find a way to add customer address to request, and send in request for new/create customer
            request.merchantCapabilities = PKMerchantCapability.Capability3DS
            request.requiredShippingAddressFields = PKAddressField.PostalAddress
            request.requiredBillingAddressFields = PKAddressField.PostalAddress
        }
        
        print(request)
        if (Stripe.canSubmitPaymentRequest(request)) {
            print("stripe can submit payment request")
            let paymentController = PKPaymentAuthorizationViewController(paymentRequest: request)
            paymentController.delegate = self
            self.presentViewController(paymentController, animated: true, completion: nil)
        } else {
            print("something went wrong")
            // let paymentController = PaymentViewController()
            // Below displays manual credit card entry forms
            // presentViewController(paymentController, animated: true, completion: nil)
            // Show the user your own credit card form (see options 2 or 3)
        }
    }
    
    
    // STRIPE FUNCTIONS
    func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: (PKPaymentAuthorizationStatus) -> Void) {
        /*
         We'll implement this method below in 'Creating a single-use token'.
         Note that we've also been given a block that takes a
         PKPaymentAuthorizationStatus. We'll call this function with either
         PKPaymentAuthorizationStatusSuccess or PKPaymentAuthorizationStatusFailure
         after all of our asynchronous code is finished executing. This is how the
         PKPaymentAuthorizationViewController knows when and how to update its UI.
         */
        // print("in payment auth")
        handlePaymentAuthorizationWithPayment(payment) { (PKPaymentAuthorizationStatus) -> () in
            // close pay modal
            
            self.paymentSuccessSignal!.emit()
            
            print("success")
            controller.dismissViewControllerAnimated(true, completion: { })
        }
    }
    
    func handlePaymentAuthorizationWithPayment(payment: PKPayment, completion: PKPaymentAuthorizationStatus -> ()) {
        STPAPIClient.sharedClient().createTokenWithPayment(payment) { (token, error) -> Void in
            if error != nil {
                completion(PKPaymentAuthorizationStatus.Failure)
                return
            }
            /*
             We'll implement this below in "Sending the token to your server".
             Notice that we're passing the completion block through.
             See the above comment in didAuthorizePayment to learn why.
             */
            print("creating backend charge with token")
            self.createBackendChargeWithToken(token, completion: completion)
        }
    }
    
    func createBackendChargeWithToken(token: STPToken!, completion: PKPaymentAuthorizationStatus -> ()) {
        // SEND REQUEST TO Argent API ENDPOINT TO EXCHANGE STRIPE TOKEN
        
        User.getProfile { (user, NSError) in
            
            let url = API_URL + "/stripe/" + (user?.id)! + "/subscriptions/" + (self.detailUser?.username)!
            
            guard let amount = self.plansArray![self.globalTag!].amount else {
                return
            }
            guard let planId = self.plansArray![self.globalTag!].id else {
                return
            }
            
            let amountInCents = Float(amount)!
            
            let parameters : [String : AnyObject] = [
                "token": String(token) ?? "",
                "amount": amountInCents,
                "plan_id": planId
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
                                let json = JSON(value)
                                print(PKPaymentAuthorizationStatus.Success)
                                completion(PKPaymentAuthorizationStatus.Success)
                                showGlobalNotification("Successfully subscribed to plan", duration: 3.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.brandGreen())
                                
                                guard let amount = self.plansArray![self.globalTag!].amount else {
                                    return
                                }
                                guard let interval = self.plansArray![self.globalTag!].interval else {
                                    return
                                }
                                
                                Answers.logPurchaseWithPrice(decimalWithString(self.currencyFormatter, string: amount),
                                    currency: "USD",
                                    success: true,
                                    itemName: "Payment",
                                    itemType: "Merchant Recurring Payment Signup",
                                    itemId: "sku-###",
                                    customAttributes: [
                                        "method": self.paymentMethod,
                                        "interval": interval
                                    ])
                            }
                        case .Failure(let error):
                            print(PKPaymentAuthorizationStatus.Failure)
                            completion(PKPaymentAuthorizationStatus.Failure)
                            showGlobalNotification("Failed to subscribe to plan", duration: 3.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.brandRed())
                            print(error)
                        }
                }
            }
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(controller: PKPaymentAuthorizationViewController) {
        self.paymentCancelSignal!.emit()
        controller.dismissViewControllerAnimated(true, completion: nil)
        print("dismissing")
    }
    
    func processPayment(payment: PKPayment, completion: (PKPaymentAuthorizationStatus -> Void)) {
        // Use your payment processor's SDK to finish charging your user.
        // When this is done, call completion(PKPaymentAuthorizationStatus.Success)
        completion(PKPaymentAuthorizationStatus.Failure)
        self.processPayment(payment, completion: completion)
    }

}


extension MerchantPlansViewController {
    // MARK: Credit card modal
    
    func showCreditCardModal(sender: AnyObject, tag: Int) {
        
        guard let amount = plansArray![tag].amount else {
            return
        }
        
        guard let planId =  self.plansArray![tag].id else {
            return
        }
                
        let navigationController = self.storyboard!.instantiateViewControllerWithIdentifier("creditCardEntryModalNavigationController") as! UINavigationController
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        
        print("showing credit card modal")
        // Initialize and style the terms and conditions modal
        formSheetController.presentationController?.contentViewSize = CGSizeMake(280, 280)
        formSheetController.presentationController?.shouldUseMotionEffect = true
        formSheetController.presentationController?.containerView?.backgroundColor = UIColor.pastelDarkBlue().colorWithAlphaComponent(0.75)
        formSheetController.presentationController?.containerView?.sizeToFit()
        formSheetController.presentationController?.shouldApplyBackgroundBlurEffect = true
        formSheetController.presentationController?.blurEffectStyle = UIBlurEffectStyle.Dark
        formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
        formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle.SlideFromBottom
        formSheetController.presentationController?.movementActionWhenKeyboardAppears = MZFormSheetActionWhenKeyboardAppears.CenterVertically
        formSheetController.contentViewCornerRadius = 10
        formSheetController.allowDismissByPanningPresentedView = true
        formSheetController.interactivePanGestureDismissalDirection = .All;
        
        // Blur will be applied to all MZFormSheetPresentationControllers by default
        MZFormSheetPresentationController.appearance().shouldApplyBackgroundBlurEffect = true
        
        let presentedViewController = navigationController.viewControllers.first as! CreditCardEntryModalViewController
        
        // keep passing along user data to modal
        presentedViewController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        presentedViewController.navigationItem.leftItemsSupplementBackButton = true
        
        // send detail user information for delegated charge
        presentedViewController.detailUser = detailUser
        presentedViewController.detailAmount = Float(amount)
        presentedViewController.paymentType = "recurring"
        presentedViewController.planId = planId
        
        // Be sure to update current module on storyboard
        self.presentViewController(formSheetController, animated: true, completion: nil)
        

    }
}