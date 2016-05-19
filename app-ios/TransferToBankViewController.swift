//
//  TransferToBankViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/19/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation

class TransferToBankViewController: UIViewController {
    
    @IBOutlet weak var transferButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transferButton.layer.cornerRadius = 5
        transferButton.clipsToBounds = true
        transferButton.backgroundColor = UIColor.mediumBlue()
    }
    
}

    