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
import JGProgressHUD
import JSSAlertView
import DZNEmptyDataSet
import CellAnimator
import AvePurchaseButton
import EmitterKit

class MerchantPlansViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    private var dateFormatter = NSDateFormatter()
    
    private var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    private var merchantLabel:UILabel = UILabel()
    
    private var tableView = UITableView()
    
    private var plansArray:Array<Plan>?

    private var cellReuseIdendifier = "idCellMerchantPlan"
    
    private var selectedRow: Int?

    private var selectedAmount: Float?

    var paymentSuccessSignal: Signal? = Signal()
    
    var paymentSuccessListener: Listener?

    var detailUser: User? {
        didSet {
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.childViewControllerForStatusBarStyle()?.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        
        // This will set to only one instance
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.layer.borderWidth = 1
        self.view.layer.masksToBounds = true
        // border radius
        self.view.layer.cornerRadius = 10.0
        // border
        self.view.layer.borderColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.2).CGColor
        self.view.layer.borderWidth = 1
        // drop shadow
        self.view.layer.shadowColor = UIColor.blackColor().CGColor
        self.view.layer.shadowOpacity = 0.8
        self.view.layer.shadowRadius = 3.0
        self.view.layer.shadowOffset = CGSizeMake(2.0, 2.0)
        
        
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGrayColor()
        
        //Looks for single or multiple taps.  Close keyboard on tap
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewPlanDetails(_:)))
//        view.addGestureRecognizer(tap)
        
        tableView.registerClass(MerchantPlanCell.self, forCellReuseIdentifier: cellReuseIdendifier)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        tableView.showsVerticalScrollIndicator = false
        print(self.view.frame.height)
        tableView.frame = CGRect(x: 0, y: 10, width: 300, height: 390)
        self.view.addSubview(tableView)
        
        self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        self.dateFormatter.timeStyle = NSDateFormatterStyle.LongStyle
        
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        navBar.barTintColor = UIColor.offWhite()
        navBar.translucent = false
        navBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.lightBlue(),
            NSFontAttributeName : UIFont(name: "DINAlternate-Bold", size: 18)!
        ]
        self.view.addSubview(navBar);
        let navItem = UINavigationItem(title: "Plans");
        navBar.setItems([navItem], animated: false);
        
        self.loadPlans()
    }
    
    private func loadPlans() {
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        // self.view.addSubview(activityIndicator)
        Plan.getDelegatedPlanList((detailUser?.username)!, completionHandler: { (plans, error) in
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
        
        CellAnimator.animateCell(cell, withTransform: CellAnimator.TransformTilt, andDuration: 0.3)

        if let name = plansArray![indexPath.row].name {
            cell.planNameLabel.text = name
        }
        if let amount = plansArray![indexPath.row].amount, let interval = plansArray![indexPath.row].interval {
            let fc = formatCurrency(amount, fontName: "DINAlternate-Bold", superSize: 11, fontSize: 14, offsetSymbol: 2, offsetCents: 2)
            
            let attrs: [String: AnyObject] = [
                NSForegroundColorAttributeName : UIColor.lightBlue().colorWithAlphaComponent(0.2),
                NSFontAttributeName : UIFont(name: "DINAlternate-Bold", size: 12)!
            ]
            
            let attrs2: [String: AnyObject] = [
                NSForegroundColorAttributeName : UIColor.brandGreen(),
                NSFontAttributeName : UIFont(name: "DINAlternate-Bold", size: 14)!
            ]

            // set selected row
            self.selectedRow = indexPath.row
            
            cell.planButton.attributedNormalTitle = fc
            cell.planButton.attributedConfirmationTitle = NSAttributedString(string: "Confirm", attributes: attrs2)
            cell.planButton.addTarget(self, action: #selector(self.purchaseButtonTapped(_:)), forControlEvents: .TouchUpInside)
            cell.planButton.tag = indexPath.row
            print(cell.planButton.tag)

            switch interval {
            case "day":
                let interval = NSAttributedString(string: " / day", attributes: attrs)
                cell.planAmountLabel.attributedText = fc + interval
            case "week":
                let interval = NSAttributedString(string: " / wk", attributes: attrs)
                cell.planAmountLabel.attributedText = fc + interval
            case "month":
                let interval = NSAttributedString(string: " / mo", attributes: attrs)
                cell.planAmountLabel.attributedText = fc + interval
            case "year":
                let interval = NSAttributedString(string: " / yr", attributes: attrs)
                cell.planAmountLabel.attributedText = fc + interval
            default:
                let interval = NSAttributedString(string: " / " + interval, attributes: attrs)
                cell.planAmountLabel.attributedText = fc + interval
            }
        }

        return cell
    }
    
    func purchaseButtonTapped(button: AvePurchaseButton) {
        switch button.buttonState {
        case AvePurchaseButtonState.Normal:
            button.setButtonState(AvePurchaseButtonState.Progress, animated: true)
            let tag = button.tag
            // with the button tag we have the indexPath of the table, send this into the show pay modal then apple pay modal, then select the index row path based on the button tag
            self.showPayModal(self, tag: tag)
            print("I'm listening!")
            print(paymentSuccessListener?.isListening)
            paymentSuccessListener = self.paymentSuccessSignal!.once {
                print("payment success executed")
                button.setButtonState(AvePurchaseButtonState.Confirmation, animated: true)
                button.attributedNormalTitle = NSAttributedString(string: "Subscribed", attributes: [
                    NSForegroundColorAttributeName : UIColor.brandGreen(),
                    NSFontAttributeName : UIFont(name: "DINAlternate-Bold", size: 14)!
                    ])
            }
        case AvePurchaseButtonState.Progress:
            // start the purchasing progress here, when done, go back to AvePurchaseButtonStateProgress
            // listen for completion
            break
        case AvePurchaseButtonState.Confirmation:
            break
        }
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: headerAttrs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "This user does not have any currently available plans."
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: bodyAttrs)
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "IconEmptyPlans")
    }
    
    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
        let str = ""
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleCallout)]
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

    func close() -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: Payment Options Modal
    
    func showPayModal(sender: AnyObject, tag: Int) {
        let actionController = ArgentActionController()
        actionController.headerData = "Subscribe with"
        actionController.addAction(Action("Apple Pay", style: .Default, handler: { action in
            Timeout(0.5) {
                print("showing apple pay modal")
                self.showApplePayModal(self, tag: tag)
            }
        }))
        actionController.addSection(ActionSection())
        actionController.addAction(Action("Cancel", style: .Destructive, handler: { action in
        }))
        self.presentViewController(actionController, animated: true, completion: { _ in
        })
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
        print("passed amount is")
        print(amount)
        let amt = Float(amount)!/100
        //print(amount)
        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: (detailUser?.first_name)!, amount: NSDecimalNumber(float: amt))
        ]
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
    
    func paymentCardTextFieldDidChange(textField: STPPaymentCardTextField) {
        // Toggle navigation, for example
        //        saveButton.enabled = textField.valid
    }
    
    // STRIPE SAVE METHOD
    @IBAction func save(sender: UIButton) {
        //        if let card = paymentTextField.card {
        //            STPAPIClient.sharedClient().createTokenWithCard(card) { (token, error) -> Void in
        //                if let error = error  {
        //                    print(error)
        //                }
        //                else if let token = token {
        //                    self.createBackendChargeWithToken(token) { status in
        //                        print(status)
        //                    }
        //                }
        //            }
        //        }
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
            controller.dismissViewControllerAnimated(true, completion: nil)
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
            let url = API_URL + "/v1/stripe/" + (user?.id)! + "/charge/"
            
            let headers = [
                "Authorization": "Bearer " + String(userAccessToken),
                "Content-Type": "application/json"
            ]
            let parameters : [String : AnyObject] = [
                "token": String(token) ?? "",
                "amount": 0,
                "delegatedUser": (self.detailUser?.username)!
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
                        }
                    case .Failure(let error):
                        print(PKPaymentAuthorizationStatus.Failure)
                        completion(PKPaymentAuthorizationStatus.Failure)
                        print(error)
                    }
            }
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(controller: PKPaymentAuthorizationViewController) {
        dismissViewControllerAnimated(true, completion: nil)
        controller.dismissViewControllerAnimated(true, completion: nil)
        print("dismissing")
    }
    
    
    // MARK: ALERTS
    
    func showAlert(message: String, color: UIColor, icon: String) {
        let customIcon:UIImage = UIImage(named: icon)! // your custom icon UIImage
        let alertView = JSSAlertView().show(
            self,
            title: "",
            text: message,
            buttonText: "Close",
            noButtons: false,
            color: color,
            iconImage: customIcon)
        alertView.setTextTheme(.Light) // can be .Light or .Dark
    }
}