//
//  SupportMessageViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/20/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import JGProgressHUD
import Alamofire

class SupportMessageViewController: UIViewController {
    
    @IBOutlet weak var message: UITextView!
    
    private let HUD: JGProgressHUD = JGProgressHUD.init(style: JGProgressHUDStyle.Light)

    var subject: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(subject)
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
        UIToolbar.appearance().barTintColor = UIColor.mediumBlue()
        UIToolbar.appearance().backgroundColor = UIColor.mediumBlue()
        if let font = UIFont(name: "Avenir-Book", size: 15) {
            UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: font,NSForegroundColorAttributeName:UIColor.whiteColor()], forState: UIControlState.Normal)
            
        }
        
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
            HUD.showInView(self.view!)
            HUD.textLabel.text = "Message cannot be empty"
            HUD.indicatorView = JGProgressHUDSuccessIndicatorView()
            HUD.dismissAfterDelay(2.5)
        } else {
            sendMessage()
        }
    }
    
    func sendMessage() {
        HUD.showInView(self.view!)
        User.getProfile { (user, err) in

            let parameters : [String : AnyObject] = [
                "subject": self.subject!,
                "message": self.message.text
            ]
            
            let headers : [String : String] = [
                "Content-Type": "application/json"
            ]
            
            Alamofire.request(.POST, API_URL + "/v1/message/" + (user?.id)!, parameters: parameters, encoding: .JSON, headers: headers)
                .responseJSON { (response) in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            self.HUD.textLabel.text = "Message sent!"
                            self.HUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                            self.HUD.dismissAfterDelay(1, animated: true)
                            self.message.text = ""
                        }
                    case .Failure(let error):
                        print(error)
                    }
            }
        }
    }
}