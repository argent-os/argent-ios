//
//  SupportMessageViewController.swift
//  paykloud-ios
//
//  Created by Sinan Ulkuatam on 3/20/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import SVProgressHUD

class SupportMessageViewController: UIViewController {
    
    
    @IBOutlet weak var message: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.tintColor = UIColor.darkGrayColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        addSendOnKeyboard()
        message.becomeFirstResponder()
    }
    
    // Add send toolbar
    func addSendOnKeyboard()
    {
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let sendToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, screenWidth, 50))
        // sendToolbar.barStyle = UIBarStyle.Default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Send", style: UIBarButtonItemStyle.Done, target: self, action: Selector("sendMessageAction"))

        var items: [UIBarButtonItem]? = [UIBarButtonItem]()
        items?.append(flexSpace)
        items?.append(done)
        items?.append(flexSpace)

        sendToolbar.items = items
        sendToolbar.sizeToFit()
        message.inputAccessoryView=sendToolbar
    }
    
    @IBAction func sendMessageAction() {
        SVProgressHUD.showInfoWithStatus("Sending support request")
        sendMessage()
    }
    
    func sendMessage() {
        SVProgressHUD.showSuccessWithStatus("Request sent!")
        print("message sent")
    }
}