//
//  TodayViewController.swift
//  app-notificationcenter
//
//  Created by Sinan Ulkuatam on 4/2/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var pendingAccountBalance: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("loaded nsnotificationcenter")
    
        let center = NSNotificationCenter.defaultCenter()
        print(center)
        center.addObserverForName("balance", object: nil, queue: nil) { notification in
            print("\(notification.name): \(notification.userInfo ?? [:])")
            self.pendingAccountBalance.text = notification.userInfo!["pending_bal"]?.stringValue ?? "no data to show"
        }
        
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.NewData)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: nil,
            object: nil)
    }
    
}
