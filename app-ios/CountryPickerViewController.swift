//
//  CountryPickerViewController.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 4/25/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import CountryPicker

class CountryPickerViewController:UIViewController {
    
    func countryPicker(picker: CountryPicker, didSelectCountryWithName name: String, code: String) {
        let nameLabel:UILabel = UILabel()
        let codeLabel:UILabel = UILabel()
        nameLabel.text = name
        codeLabel.text = code
    }
}