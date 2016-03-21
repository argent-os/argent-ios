//
//  AddBankViewController.swift
//  paykloud-ios
//
//  Created by Sinan Ulkuatam on 3/19/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation

class AddBankViewController: UIViewController {
    
    @IBOutlet weak var addBankButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.tintColor = UIColor.darkGrayColor()

        addBankButton.layer.cornerRadius = 0
        addBankButton.clipsToBounds = true
        addBankButton.backgroundColor = UIColor(rgba: "#1796fa")
    }
}