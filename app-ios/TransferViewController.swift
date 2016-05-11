//
//  TransferViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/11/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation

class TransferViewController: UIViewController {
    
    @IBOutlet weak var initiateTransferButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initiateTransferButton.layer.cornerRadius = 5
        initiateTransferButton.clipsToBounds = true
        initiateTransferButton.backgroundColor = UIColor.mediumBlue()
    }
    
}

    