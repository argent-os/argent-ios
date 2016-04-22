////
////  PaymentViewController.m
////
////  Created by Alex MacCaw on 2/14/13.
////  Copyright (c) 2013 Stripe. All rights reserved.
////
//import Stripe
//class PaymentViewController: UIViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = UIColor.whiteColor()
//        self.title = "Buy a shirt"
//        if self.respondsToSelector("setEdgesForExtendedLayout:") {
//            self.edgesForExtendedLayout = .None
//        }
//            // Setup save button
//        var title: String = "Pay $\(self.amount)"
//        var saveButton: UIBarButtonItem = UIBarButtonItem(title: title, style: .Done, target: self, action: "save:")
//        var cancelButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel:")
//        saveButton.enabled = false
//        self.navigationItem.leftBarButtonItem = cancelButton
//        self.navigationItem.rightBarButtonItem = saveButton
//            // Setup payment view
//        var paymentTextField: STPPaymentCardTextField = STPPaymentCardTextField()
//        paymentTextField.delegate = self
//        paymentTextField.cursorColor = UIColor.purpleColor()
//        self.paymentTextField = paymentTextField
//        self.view!.addSubview(paymentTextField)
//            // Setup Activity Indicator
//        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
//        activityIndicator.hidesWhenStopped = true
//        self.activityIndicator = activityIndicator
//        self.view!.addSubview(activityIndicator)
//    }
//
//    func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        var padding: CGFloat = 15
//        var width: CGFloat = CGRectGetWidth(self.view.frame) - (padding * 2)
//        self.paymentTextField.frame = CGRectMake(padding, padding, width, 44)
//        self.activityIndicator.center = self.view.center
//    }
//
////    func paymentCardTextFieldDidChange(textField: nonnull STPPaymentCardTextField) {
////        self.navigationItem.rightBarButtonItem.enabled = textField.isValid
////    }
//
//    func cancel(sender: AnyObject) {
//        self.presentingViewController.dismissViewControllerAnimated(true, completion: { _ in })
//    }
//
//    func save(sender: AnyObject) {
//        if !self.paymentTextField.isValid() {
//            return
//        }
//        if !Stripe.defaultPublishableKey() {
//            var error: NSError = NSError.errorWithDomain(StripeDomain, code: STPInvalidRequestError, userInfo: [NSLocalizedDescriptionKey: "Please specify a Stripe Publishable Key in Constants.m"])
//            self.delegate.paymentViewController(self, didFinish: error)
//            return
//        }
//        self.activityIndicator.startAnimating()
////        STPAPIClient.sharedClient().createTokenWithCard(self.paymentTextField.cardParams, completion: {() -> (STPToken*token,NSError*error) in
////            self.activityIndicator.stopAnimating()
////            if error != nil {
////                self.delegate.paymentViewController(self, didFinish: error)
////            }
////            self.backendCharger.createBackendChargeWithToken(token, completion: {(result: STPBackendChargeResult, error: NSError) -> Void in
////                if error != nil {
////                    self.delegate.paymentViewController(self, didFinish: error)
////                    return
////                }
////                self.delegate.paymentViewController(self, didFinish: nil)
////            })
////        })
//    }
//}