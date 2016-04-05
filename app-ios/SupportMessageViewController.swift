//
//  SupportMessageViewController.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 3/20/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import JGProgressHUD

class SupportMessageViewController: UIViewController {
    
    
    @IBOutlet weak var message: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.navigationController!.navigationBar.tintColor = UIColor.darkGrayColor()
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
        let done: UIBarButtonItem = UIBarButtonItem(title: "Send", style: UIBarButtonItemStyle.Done, target: self, action: #selector(SupportMessageViewController.sendMessageAction))

        var items: [UIBarButtonItem]? = [UIBarButtonItem]()
        items?.append(flexSpace)
        items?.append(done)
        items?.append(flexSpace)

        sendToolbar.items = items
        sendToolbar.sizeToFit()
        message.inputAccessoryView=sendToolbar
    }
    
    @IBAction func sendMessageAction() {
        let HUD: JGProgressHUD = JGProgressHUD.init(style: JGProgressHUDStyle.Dark)
        HUD.showInView(self.view!)
        HUD.dismissAfterDelay(0.5)
        sendMessage()
    }
    
    func sendMessage() {
        let HUD: JGProgressHUD = JGProgressHUD.init(style: JGProgressHUDStyle.Dark)
        HUD.showInView(self.view!)
        HUD.textLabel.text = "Message sent!"
        HUD.indicatorView = JGProgressHUDSuccessIndicatorView()
        HUD.dismissAfterDelay(2.5)
        print("message sent")
    }
}