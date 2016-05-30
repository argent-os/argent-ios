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
        planNameLabel.font = UIFont(name: "DINAlternate-Bold", size: 16)
        planNameLabel.textColor = UIColor.lightBlue()
        
        planAmountLabel.frame = CGRect(x: 20, y: 40, width: 180, height: 20)
        planAmountLabel.textColor = UIColor.lightBlue()
        
        planButton.frame = CGRect(x: self.contentView.frame.size.width-95, y: 25, width: 80, height: 30)
        planButton.addTarget(self, action: #selector(MerchantPlanCell.purchaseButtonTapped(_:)), forControlEvents: .TouchUpInside)
        planButton.buttonState = AvePurchaseButtonState.Normal
//        planButton.normalTitle = "N/A"
//        planButton.confirmationTitle = "Confirm"
        planButton.normalColor = UIColor.iosBlue()
        planButton.tintColor = UIColor.iosBlue()
        planButton.confirmationColor = UIColor.brandGreen()
//        planButton.sizeToFit()

    }
    
    func purchaseButtonTapped(button: AvePurchaseButton) {
        switch button.buttonState {
        case AvePurchaseButtonState.Normal:
            button.setButtonState(AvePurchaseButtonState.Confirmation, animated: true)
        case AvePurchaseButtonState.Confirmation:
            // start the purchasing progress here, when done, go back to
            // AvePurchaseButtonStateProgress
            button.setButtonState(AvePurchaseButtonState.Progress, animated: true)
            Timeout(1) {
                button.setButtonState(.Normal, animated: true)
            }
//            self.startPurchaseWithCompletionHandler({() -> Void in
//                button.setButtonState(AvePurchaseButtonState.Normal, animated: true)
//            })
        case AvePurchaseButtonState.Progress:
            break
        }
        
    }
}
