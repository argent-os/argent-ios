//
//  MerchantPlanCell.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/28/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import AvePurchaseButton

class MerchantPlanCell: UITableViewCell {
    
    var planNameLabel = UILabel()
    var planAmountLabel = UILabel()
    let planButton: AvePurchaseButton = AvePurchaseButton()
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(planNameLabel)
        self.contentView.addSubview(planAmountLabel)
        self.contentView.addSubview(planButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        planNameLabel.frame = CGRect(x: 20, y: 20, width: 180, height: 20)
        planNameLabel.font = UIFont(name: "MyriadPro-Regular", size: 16)
        planNameLabel.textColor = UIColor.darkBlue()
        
        planAmountLabel.frame = CGRect(x: 20, y: 40, width: 180, height: 20)
        planAmountLabel.textColor = UIColor.lightBlue()
        
        planButton.frame = CGRect(x: self.contentView.frame.size.width-95, y: 25, width: 80, height: 30)
        planButton.buttonState = AvePurchaseButtonState.Normal
        planButton.normalColor = UIColor.pastelBlue()
        planButton.tintColor = UIColor.pastelBlue()
        planButton.confirmationColor = UIColor.brandGreen()
        // planButton.sizeToFit()
    }
}
