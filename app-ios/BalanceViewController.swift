//
//  BalanceViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 4/1/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import UICountingLabel
import BEMSimpleLineGraph

class BalanceViewController: UIViewController {

    
    @IBOutlet weak var pendingAmountGraph: BEMSimpleLineGraphView!
    @IBOutlet weak var availableAmountGraph: BEMSimpleLineGraphView!
    @IBOutlet weak var availableBalanceLabel: UICountingLabel!
    @IBOutlet weak var pendingBalanceLabel: UICountingLabel!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var myGraph: BEMSimpleLineGraphView = BEMSimpleLineGraphView(frame: CGRectMake(0, 0, 320, 200))
//        myGraph.dataSource = self
//        myGraph.delegate = self
//        self.view!.addSubview(myGraph)
        
    }
    
    // VIEW DID APPEAR
    override func viewDidAppear(animated: Bool) {
        
    }
    

}