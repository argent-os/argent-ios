//
//  BalanceViewController.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 4/1/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import UICountingLabel

class BalanceViewController: UIViewController {
    
    @IBOutlet weak var availableBalanceLabel: UICountingLabel!
    @IBOutlet weak var pendingBalanceLabel: UICountingLabel!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // VIEW DID APPEAR
    override func viewDidAppear(animated: Bool) {
        
    }
}