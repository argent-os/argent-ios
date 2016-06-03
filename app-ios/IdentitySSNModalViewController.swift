//
//  IdentitySSNModalViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 6/2/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import MZFormSheetPresentationController
import VMaskTextField

class IdentitySSNModalViewController: UIViewController, UITextFieldDelegate {
    
    let titleLabel = UILabel()
    
    let ssnTextField = VMaskTextField()
    
    let submitSSNButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This will set to only one instance
        
        self.view.backgroundColor = UIColor.offWhite()
        
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        _ = screen.size.width
        _ = screen.size.height
        
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGrayColor()
        
        titleLabel.frame = CGRect(x: 0, y: 35, width: 300, height: 20)
        titleLabel.text = "Enter your SSN"
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "HelveticaNeue", size: 18)
        titleLabel.textColor = UIColor.lightBlue()
        self.view.addSubview(titleLabel)
        
        ssnTextField.frame = CGRect(x: 20, y: 70, width: 260, height: 150)
        ssnTextField.placeholder = "xxx-xx-xxxx"
        ssnTextField.alpha = 0.8
        ssnTextField.textAlignment = .Center
        ssnTextField.font = UIFont(name: "HelveticaNeue", size: 20)
        ssnTextField.textColor = UIColor.lightBlue()
        self.view.addSubview(ssnTextField)
//        ssnTextField.mask = "###-##-####"
        ssnTextField.mask = "#########"
        ssnTextField.delegate = self
        ssnTextField.keyboardType = .NumberPad
        ssnTextField.secureTextEntry = true
        ssnTextField.becomeFirstResponder()
        
        submitSSNButton.frame = CGRect(x: 20, y: 230, width: 260, height: 50)
        submitSSNButton.layer.borderColor = UIColor.whiteColor().CGColor
        submitSSNButton.layer.borderWidth = 0
        submitSSNButton.layer.cornerRadius = 10
        submitSSNButton.layer.masksToBounds = true
        submitSSNButton.setBackgroundColor(UIColor.lightBlue(), forState: .Normal)
        submitSSNButton.setBackgroundColor(UIColor.lightBlue().colorWithAlphaComponent(0.5), forState: .Highlighted)
        var attribs: [String: AnyObject] = [:]
        attribs[NSFontAttributeName] = UIFont(name: "DINAlternate-Bold", size: 14)
        attribs[NSForegroundColorAttributeName] = UIColor.whiteColor()
        let str = NSAttributedString(string: "Submit", attributes: attribs)
        submitSSNButton.setAttributedTitle(str, forState: .Normal)
        submitSSNButton.addTarget(self, action: #selector(self.submitSSN(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(submitSSNButton)
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return ssnTextField.shouldChangeCharactersInRange(range, replacementString: string)
    }
    
    func submitSSN(sender: AnyObject) {
        
    }
    
    override func viewDidDisappear(animated: Bool) {
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    func close() -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}