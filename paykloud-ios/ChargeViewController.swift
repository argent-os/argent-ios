//
//  ChargeViewController.swift
//  paykloud-ios
//
//  Created by Sinan Ulkuatam on 3/3/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import VENCalculatorInputView

class ChargeViewController: UIViewController, VENCalculatorInputViewDelegate {
    
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var chargeInputView: VENCalculatorInputTextField!
    // Set up initial view height adjustment to false
    var alreadyAdjusted:Bool = false

    var currentString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculateButton.layer.cornerRadius = 5
        calculateButton.layer.masksToBounds = true
        
        // Transparent navigation bar
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationBar.shadowImage = UIImage()
        navigationBar.translucent = true
        
        // Set up auto align keyboard with ui button
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        chargeInputView.becomeFirstResponder()
    }
    
    func calculatorInputView(inputView: VENCalculatorInputView, didTapKey key: String) {
        print("Just tapped key: %@", key)
        // Handle the input. Something like [myTextField insertText:key];
    }

    func calculatorInputViewDidTapBackspace(calculatorInputView: VENCalculatorInputView) {
        print("Just tapped backspace.")
        // Handle the backspace. Something like [myTextField deleteBackward];
    }
    
    //Changing Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    //Textfield delegates
    func textField(textField: VENCalculatorInputTextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print("executing")
        // Construct the text that will be in the field if this change is accepted
        var oldText = textField.text! as NSString
        var newText = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        var newTextString = String(newText)
        
        let digits = NSCharacterSet.decimalDigitCharacterSet()
        var digitText = ""
        for c in newTextString.unicodeScalars {
            if digits.longCharacterIsMember(c.value) {
                digitText.append(c)
            }
        }
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        var numberFromField = Double(digitText)!/100
        newText = formatter.stringFromNumber(numberFromField)!
        
        print(newText)
        textField.text = newText
        
        return false
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // Adjusts keyboard height to view
    func adjustingHeight(show:Bool, notification:NSNotification) {
        if(alreadyAdjusted == false) {
            // Check if already adjusted height
            var userInfo = notification.userInfo!
            let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
            let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
            let changeInHeight = (CGRectGetHeight(keyboardFrame) - 5) * (show ? 1 : -1)
            UIView.animateWithDuration(animationDurarion, animations: { () -> Void in
                self.bottomConstraint.constant += changeInHeight
                print(self.bottomConstraint.constant)
                if(self.bottomConstraint.constant < 0) {
                    print("negative constant, adding more")
                    self.bottomConstraint.constant += (-1 * (2*changeInHeight))
                    print("new val", self.bottomConstraint.constant)
                }
            })
            // Already adjusted height so make it true so it doesn't continue adjusting everytime a label is focused
            alreadyAdjusted = true
        }
    }
    
    
    func keyboardWillShow(notification:NSNotification) {
        adjustingHeight(true, notification: notification)
    }
    
    func keyboardWillHide(notification:NSNotification) {
        adjustingHeight(false, notification: notification)
    }
    
    override func viewWillDisappear(animated: Bool) {
        dismissKeyboard()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        super.viewWillDisappear(animated)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    

}