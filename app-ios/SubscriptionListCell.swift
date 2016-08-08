//
//  SubscriptionListCell.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 8/6/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import Former

final class SubscriptionListCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var planSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}