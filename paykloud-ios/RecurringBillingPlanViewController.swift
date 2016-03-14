//
//  RecurringBillingPlanViewController.swift
//  paykloud-ios
//
//  Created by Sinan Ulkuatam on 3/14/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RecurringBillingViewController: UIViewController {
    
    @IBOutlet weak var textFieldPlanID: UITextField!
    @IBOutlet weak var textFieldPlanName: UITextField!
    @IBOutlet weak var textFieldPlanCurrency: UITextField!
    @IBOutlet weak var textFieldPlanAmount: UITextField!
    @IBOutlet weak var textFieldPlanInterval: UITextField!
    @IBOutlet weak var textFieldPlanTrialPeriod: UITextField!
    @IBOutlet weak var textFieldPlanStatementDescription: UITextField!
    @IBOutlet weak var buttonAddPlan: UIButton!
    @IBOutlet weak var buttonReturnHome: UIButton!
    
    @IBAction func addPlanButtonTapped(sender: AnyObject) {
    
        print("add plan tapped")
        // Post plan using Alamofire
        let plan_id = textFieldPlanID.text! as String
        let plan_name = textFieldPlanName.text! as String
        let plan_currency = textFieldPlanCurrency.text! as String
        let plan_amount = textFieldPlanAmount.text!
        let plan_interval = textFieldPlanInterval.text! as String
//        print(textFieldPlanTrialPeriod.text!)
//        print(textFieldPlanStatementDescription.text!)
        
        print("plan id is", plan_id)
        let stripeKey = userData!["stripe"]["secretKey"].stringValue
        print(stripeKey)
        let headers = [
            "Authorization": "Bearer " + stripeKey,
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let parameters : [String : AnyObject] = [
            "id": plan_id,
            "amount": plan_amount,
            "interval": plan_interval,
            "name": plan_name,
            "currency": plan_currency
        ]
        
        Alamofire.request(.POST, stripeApiUrl + "/v1/plans",
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view loaded")
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func addPlanButtonTapped() {
        
    }
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}