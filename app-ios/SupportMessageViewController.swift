//
//  SupportMessageViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/20/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import Alamofire
import CWStatusBarNotification

class SupportMessageViewController: UIViewController {
    
    @IBOutlet weak var message: UITextView!
    
    var subject: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(subject)
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
        let done: UIBarButtonItem = UIBarButtonItem(title: "Send", style: UIBarButtonItemStyle.Done, target: self, action: #selector(self.sendMessageAction))

        UIToolbar.appearance().barTintColor = UIColor.brandGreen()
        UIToolbar.appearance().backgroundColor = UIColor.brandGreen()

        done.setTitleTextAttributes([
            NSFontAttributeName : UIFont(name: "MyriadPro-Regular", size: 15)!,
            NSForegroundColorAttributeName : UIColor.whiteColor()
            ], forState: .Normal)
        
        var items: [UIBarButtonItem]? = [UIBarButtonItem]()
        items?.append(flexSpace)
        items?.append(done)
        items?.append(flexSpace)

        sendToolbar.items = items
        sendToolbar.sizeToFit()
        message.inputAccessoryView=sendToolbar
    }
    
    @IBAction func sendMessageAction() {
        if message.text == "" {
            showGlobalNotification("Message cannot be empty", duration: 3.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.StatusBarNotification, color: UIColor.brandRed())
        } else {
            sendMessage()
        }
    }
    
    func sendMessage() {
        User.getProfile { (user, err) in

            let parameters : [String : AnyObject] = [
                "subject": self.subject!,
                "message": self.message.text
            ]
            
            let headers : [String : String] = [
                "Content-Type": "application/json"
            ]
            
            Alamofire.request(.POST, API_URL + "/message/" + (user?.id)!, parameters: parameters, encoding: .JSON, headers: headers)
                .responseJSON { (response) in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            showGlobalNotification("Message sent!", duration: 3.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.StatusBarNotification, color: UIColor.brandGreen())
                            self.message.text = ""
                        }
                    case .Failure(let error):
                        print(error)
                    }
            }
        }
    }
}