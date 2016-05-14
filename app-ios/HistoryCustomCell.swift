//
//  HistoryCustomCell.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/13/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit

class HistoryCustomCell: UITableViewCell {
    
    @IBOutlet weak var lblAmount: UILabel!
    
    @IBOutlet weak var lblCreditDebit: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
