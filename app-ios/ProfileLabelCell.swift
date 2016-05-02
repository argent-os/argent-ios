//
//  ProfileLabelCell.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/19/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import Former

final class ProfileLabelCell: UITableViewCell, InlineDatePickerFormableRow, InlinePickerFormableRow {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var displayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        titleLabel.textColor = .formerColor()
//        displayLabel.textColor = .formerSubColor()
    }
    
    func formTitleLabel() -> UILabel? {
        return titleLabel
    }
    
    func formDisplayLabel() -> UILabel? {
        return displayLabel
    }
    
    func updateWithRowFormer(rowFormer: RowFormer) {}
}