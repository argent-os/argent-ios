//
//  RiskProfileViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/4/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation

class RiskProfileViewController: UIViewController {
    
    @IBOutlet weak var enableRiskProfileButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.darkBlue()
        
        enableRiskProfileButton.layer.cornerRadius = 5
        enableRiskProfileButton.clipsToBounds = true
        enableRiskProfileButton.backgroundColor = UIColor.mediumBlue()
    }

}