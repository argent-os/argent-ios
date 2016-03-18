//
//  AddCustomerViewController.swift
//  paykloud-ios
//
//  Created by Sinan Ulkuatam on 3/15/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AddCustomerViewController: UIViewController {
    
    @IBOutlet weak var textFieldCustomerEmail: UITextField!
    @IBOutlet weak var textFieldCustomerDescription: UITextField!
    @IBOutlet weak var buttonAddCustomer: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view loaded")
    
        textFieldCustomerEmail.keyboardType = .EmailAddress
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func addCustomerButtonTapped(sender: AnyObject) {
        
        print("add customer tapped")
        // Post plan using Alamofire
        let cust_email = textFieldCustomerEmail.text! as String
        let cust_desc = textFieldCustomerDescription.text! as String
        
        let stripeKey = userData!["user"]["stripe"]["secretKey"].stringValue
        
        print("stripe key is", stripeKey)
        let headers = [
            "Authorization": "Bearer " + stripeKey,
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let parameters : [String : AnyObject] = [
            "email": cust_email,
            "description": cust_desc,
        ]
        
        Alamofire.request(.POST, stripeApiUrl + "/v1/customers",
            parameters: parameters,
            encoding:.URL,
            headers: headers)
            .responseJSON { response in
                print(response.request) // original URL request
                print(response.response?.statusCode) // URL response
                print(response.data) // server data
                print(response.result) // result of response serialization
                
                // go to main view
                if(response.response?.statusCode == 200) {
                    print("green light")
                } else {
                    print("red light")
                }
                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print(json)
                        self.dismissKeyboard()
                        
                    }
                case .Failure(let error):
                    print(error)
                }
        }
        
    }

    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}