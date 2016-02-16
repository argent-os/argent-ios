//
//  PresentedTableViewController.swift
//  paykloud-ios
//
//  Created by Sinan Ulkuatam on 2/15/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit

class PresentedTableViewController: UIViewController {
    

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var switchAgreement: UISwitch!
    var textFieldBecomeFirstResponder: Bool = false
    var passingString1: String?
    var passingString2: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This will set to only one instance
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: Selector("close"))
        
        if let text1 = self.passingString1 {
            print(text1)
            // self.textField.text = text;
        }
        if let text2 = self.passingString2 {
            print(text2)
            // self.textField.text = text;
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if textFieldBecomeFirstResponder {
//            self.textField.becomeFirstResponder()
        }
    }
    
    func close() -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}