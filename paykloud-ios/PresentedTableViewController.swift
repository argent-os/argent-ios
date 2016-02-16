//
//  PresentedTableViewController.swift
//  paykloud-ios
//
//  Created by Sinan Ulkuatam on 2/15/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit

class PresentedTableViewController: UINavigationController {
    
    @IBOutlet weak var textField: UITextField!
    var textFieldBecomeFirstResponder: Bool = false
    var passingString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: Selector("close"))
        
        if let text = self.passingString {
            
            //self.textField.text = text;
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if textFieldBecomeFirstResponder {
            //self.textField.becomeFirstResponder()
        }
    }
    
    func close() -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}