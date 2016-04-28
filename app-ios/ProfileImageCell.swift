//
//  ProfileImageCell.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 3/19/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import Former

final class ProfileImageCell: UITableViewCell, LabelFormableRow {
    
    // MARK: Public
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        titleLabel.textColor = .formerColor()
        iconView.backgroundColor = UIColor.clearColor()
        iconView.layer.borderColor = UIColor.lightGrayColor().CGColor
        iconView.layer.borderWidth = 2
        iconView.layer.cornerRadius = CGRectGetHeight(iconView.bounds) / 2
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        if iconViewColor == nil {
            iconViewColor = iconView.backgroundColor
        }
        super.setHighlighted(highlighted, animated: animated)
        if let color = iconViewColor {
            iconView.backgroundColor = color
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        if iconViewColor == nil {
            iconViewColor = iconView.backgroundColor
        }
        super.setSelected(selected, animated: animated)
        if let color = iconViewColor {
            iconView.backgroundColor = color
        }
    }
    
    func formTextLabel() -> UILabel? {
        return titleLabel
    }
    
    func formSubTextLabel() -> UILabel? {
        return nil
    }
    
    func updateWithRowFormer(rowFormer: RowFormer) {}
    
    // MARK: Private
    
    private var iconViewColor: UIColor?
}