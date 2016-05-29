//
//  MerchantPlanCell.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/28/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit

class MerchantPlanCell: UITableViewCell {
    
    var planNameLabel = UILabel()
    var planAmountLabel = UILabel()
    var planButton = UIButton()
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
        
        activityIndicator.center = self.contentView.center
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        self.contentView.addSubview(activityIndicator)
        Timeout(0.3) {
            self.activityIndicator.stopAnimating()
        }
        
        planNameLabel.frame = CGRect(x: 20, y: 20, width: 70, height: 20)
        planNameLabel.font = UIFont(name: "ArialRoundedMTBold", size: 16)
        planNameLabel.textColor = UIColor.lightBlue()
        
        planAmountLabel.frame = CGRect(x: 20, y: 40, width: 70, height: 20)
        planAmountLabel.textColor = UIColor.lightBlue()
        
        planButton.frame = CGRect(x: self.contentView.frame.size.width-110, y: self.contentView.frame.size.height*0.5-15, width: 90, height: 30)
        planButton.setTitle("Subscribe", forState: .Normal)
        let str1 = NSAttributedString(string: "Subscribe", attributes: [
            NSForegroundColorAttributeName : UIColor.lightBlue(),
            NSFontAttributeName : UIFont(name: "ArialRoundedMTBold", size: 14.0)!
        ])
        let str2 = NSAttributedString(string: "Subscribe", attributes: [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "ArialRoundedMTBold", size: 14.0)!
        ])
        let str3 = NSAttributedString(string: "Unsubscribe", attributes: [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "ArialRoundedMTBold", size: 14.0)!
        ])
        planButton.setAttributedTitle(str1, forState: .Normal)
        planButton.setAttributedTitle(str2, forState: .Highlighted)
        planButton.setAttributedTitle(str3, forState: .Selected)
        planButton.setBackgroundColor(UIColor.clearColor(), forState: .Normal)
        planButton.setBackgroundColor(UIColor.lightBlue(), forState: .Highlighted)
        planButton.setBackgroundColor(UIColor.lightBlue(), forState: .Selected)
        planButton.layer.cornerRadius = 10
        planButton.layer.masksToBounds = true
        planButton.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.5).CGColor
        planButton.layer.borderWidth = 1

    }
}
