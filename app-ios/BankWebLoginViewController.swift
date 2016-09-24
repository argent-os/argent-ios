//
//  BankWebLoginViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 8/29/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import CWStatusBarNotification
import SwiftyJSON
import Alamofire
import Crashlytics

class BankWebLoginViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    
    @IBOutlet var containerView : UIView!
    
    var webView: WKWebView?
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func loadView() {
        super.loadView()
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.width
        let screenHeight = screen.height
        
        let configuration = WKWebViewConfiguration()
        let controller = WKUserContentController()
        controller.addScriptMessageHandler(self, name: "observe")
        configuration.userContentController = controller
        
        self.webView = WKWebView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), configuration: configuration)
        self.webView?.contentMode = .ScaleAspectFit
        self.webView?.UIDelegate = self
        self.view = self.webView!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ENVIRONMENT == "DEV" {
            let url = NSURL(string:"http://localhost:5000/link")
            let req = NSURLRequest(URL:url!)
            self.webView!.loadRequest(req)
        } else if ENVIRONMENT == "PROD" {
            let url = NSURL(string:"https://www.argentapp.com/link")
            let req = NSURLRequest(URL:url!)
            self.webView!.loadRequest(req)
        }
        
    }
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        
        // print("Received \(message.body)")
        // convert the json to an nsdict
        
        let _ = String(message.body["access_token"].map({ (unwrap) -> () in
           self.updateUserPlaidToken(unwrap)
        }))
        let _ = String(message.body["stripe_bank_account_token"].map({ (unwrap) -> () in
            self.linkBankToStripe(unwrap)
        }))
        
    }
    
    func updateUserPlaidToken(accessToken: AnyObject) {
        
        if(userAccessToken != nil) {
            User.getProfile { (user, NSError) in
                
                let endpoint = API_URL + "/profile/" + (user?.id)!
                
                let headers = [
                    "Authorization": "Bearer " + (userAccessToken as! String),
                    "Content-Type": "application/json"
                ]
                
                let plaidObj = [ "access_token" : accessToken ]
                let plaidNSDict = plaidObj as NSDictionary //no error message
                
                let parameters : [String : AnyObject] = [
                    "plaid" : plaidNSDict
                ]
                
                Alamofire.request(.PUT, endpoint, parameters: parameters, encoding: .JSON, headers: headers).responseJSON {
                    response in
                    switch response.result {
                    case .Success:
                        Answers.logCustomEventWithName("Plaid token update success",
                            customAttributes: [:])
                    case .Failure(let error):
                        print(error)
                        Answers.logCustomEventWithName("Plaid token update failed",
                            customAttributes: [
                                "error": error.localizedDescription
                            ])
                    }
                }
            }
        }
    }
    
    func linkBankToStripe(bankToken: AnyObject) {
        
        if(userAccessToken != nil) {
            User.getProfile { (user, NSError) in
                
                let endpoint = API_URL + "/stripe/" + user!.id + "/external_account"
                
                let headers = [
                    "Authorization": "Bearer " + (userAccessToken as! String),
                    "Content-Type": "application/json"
                ]
                
                let parameters = ["external_account": bankToken]

                Alamofire.request(.POST, endpoint, parameters: parameters, encoding: .JSON, headers: headers).responseJSON {
                    response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let data = JSON(value)
                            
                            if data["error"]["message"].stringValue != "" {
                                showAlert(.Error, title: "Error", msg: data["error"]["message"].stringValue)
                                
                                self.dismissViewControllerAnimated(true, completion: nil)

                                Answers.logCustomEventWithName("Bank account link failure",
                                    customAttributes: [:])
                            } else {
                                showAlert(.Success, title: "Success", msg: "Your bank account is now linked!")
                                
                                self.dismissViewControllerAnimated(true, completion: nil)
                                
                                Answers.logCustomEventWithName("Link bank to Stripe success",
                                    customAttributes: [:])
                            }
                        }
                    case .Failure(let error):
                        print(error)
                        
                        self.dismissViewControllerAnimated(true, completion: nil)

                        Answers.logCustomEventWithName("Link bank to Stripe failed",
                            customAttributes: [
                                "error": error.localizedDescription
                            ])
                    }
                }
            }
        }
    }
}