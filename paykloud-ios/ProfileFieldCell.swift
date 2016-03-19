//
//  ProfileFieldCell.swift
//  paykloud-ios
//
//  Created by Sinan Ulkuatam on 3/19/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import Former

final class ProfileFieldCell: UITableViewCell, TextFieldFormableRow {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        titleLabel.textColor = .formerColor()
//        textField.textColor = .formerSubColor()
    }
    
    func formTextField() -> UITextField {
        return textField
    }
    
    func formTitleLabel() -> UILabel? {
        return titleLabel
    }
    
    func updateWithRowFormer(rowFormer: RowFormer) {}
}