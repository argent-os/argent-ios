//
//  TermsViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 2/16/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit

class TermsViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    var passingString1: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        
    }
    
    func close() -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}