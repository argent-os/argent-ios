//
//  BankConnectedCell.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 6/12/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit

class BankConnectedCell: UITableViewCell {
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var bankTitleLabel: UILabel!
    @IBOutlet weak var bankRoutingLabel: UILabel!
    @IBOutlet weak var bankStatusLabel: UILabel!
    @IBOutlet weak var bankLastFourLabel: UILabel!
    @IBOutlet weak var bankLogoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
