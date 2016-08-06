//
//  AmountInputCell.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 8/6/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import Former
import TRCurrencyTextField

final class AmountInputCell: UITableViewCell, TextFieldFormableRow, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var regularTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        regularTextField.borderStyle = .None
        regularTextField.layer.cornerRadius = 0
        regularTextField.layer.masksToBounds = true
        
    }
    
    func formTextField() -> UITextField {
        //regularTextField = TRCurrencyTextField()
        
        return regularTextField
    }
    
    func formTitleLabel() -> UILabel? {
        return titleLabel
    }
    
    func updateWithRowFormer(rowFormer: RowFormer) {}
}