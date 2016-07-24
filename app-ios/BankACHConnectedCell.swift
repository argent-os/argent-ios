//
//  BankACHConnectedCell.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 7/24/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit

class BankACHConnectedCell: UITableViewCell {
    
    @IBOutlet weak var bankTitleLabel: UILabel!
    @IBOutlet weak var bankStatusLabel: UILabel!
    @IBOutlet weak var bankLogoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
