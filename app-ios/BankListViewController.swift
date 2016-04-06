//
//  BankListViewController.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 4/5/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class BankListViewController: UITableViewController {
    
    @IBOutlet weak var addBankButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()

        // request to api to get account data as json, put in list and table
        // curl -X GET -i -H "Content-Type: application/json" -d '{"access_token": "test_bofa"}' http://192.168.1.232:5001/v1/plaid/auth
        
        let parameters : [String : AnyObject] = [
            "access_token" : "test_bofa"
        ]
        
        let headers = [
            "Authorization": "Bearer " + (userAccessToken as! String),
            "Content-Type": "application/json"
        ]
        
        let endpoint = apiUrl + "/v1/plaid/auth"
        
        print(endpoint)
        print(parameters)
        print(headers)
        
        Alamofire.request(.GET, endpoint, parameters: parameters, encoding: .URL, headers: headers)
            .responseJSON { response in
                print(response)
                switch response.result {
                case .Success:
                    print("success")
                    if let value = response.result.value {
                        let data = JSON(value)
                        print("send plaid endpoint")
                        print(data)
                    }
                case .Failure(let error):
                    print(error)
                }
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}