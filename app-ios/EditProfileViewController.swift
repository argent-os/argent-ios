//
//  EditProfileViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/18/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit
import Foundation
import Former
import JSSAlertView

final class EditProfileViewController: FormViewController, UINavigationBarDelegate {
    
    var dic: Dictionary<String, AnyObject> = [:]

    var dicAccount: Dictionary<String, AnyObject> = [:]

    var dicAccountData: Dictionary<String, AnyObject> = [:]

    var dicLegalEntityAddress: Dictionary<String, AnyObject> = [:]

    var dicLegalEntityDob: Dictionary<String, AnyObject> = [:]

    var dicLegalEntityBusinessName: Dictionary<String, AnyObject> = [:]

    var dicLegalEntityType: Dictionary<String, AnyObject> = [:]

    var detailUser: User? {
        didSet {
            // config
        }
    }
    
    // MARK: Public
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
        super.viewDidLoad()
        User.getProfile { (user, err) in
            let user = user
            Account.getStripeAccount { (acct, err) in
                let acct = acct
                if user != nil && acct != nil {
                    self.configure(user!, account: acct!)
                }
            }
        }
    }
    
    // MARK: Private
    
    private lazy var formerInputAccessoryView: FormerInputAccessoryView = FormerInputAccessoryView(former: self.former)

    func save(sender: AnyObject) {

        let b_name = NSUserDefaults.standardUserDefaults().valueForKey("business_name")
        let b_type = NSUserDefaults.standardUserDefaults().valueForKey("type") ?? ""
        let b_state = NSUserDefaults.standardUserDefaults().valueForKey("state") ?? ""
        let b_city = NSUserDefaults.standardUserDefaults().valueForKey("city") ?? ""
        let b_postal_code = NSUserDefaults.standardUserDefaults().valueForKey("postal_code") ?? ""
        let b_country = NSUserDefaults.standardUserDefaults().valueForKey("country") ?? ""
        let b_line1 = NSUserDefaults.standardUserDefaults().valueForKey("line1") ?? ""
        let b_ssn = NSUserDefaults.standardUserDefaults().valueForKey("ssn_last_4") ?? ""
        let b_ein = NSUserDefaults.standardUserDefaults().valueForKey("business_tax_id") ?? ""
        let b_dob_day = "" //NSUserDefaults.standardUserDefaults().valueForKey("dob_day") else { return }
        let b_dob_month = "" // NSUserDefaults.standardUserDefaults().valueForKey("dob_month") else { return }
        let b_dob_year = "" //NSUserDefaults.standardUserDefaults().valueForKey("dob_year") else { return }

//      "dob": [
//        "day": b_dob_day,
//        "month": b_dob_month,
//        "year": b_dob_year
//      ]
        
        let legalContent: [String: AnyObject] = [
            "ssn_last_4": b_ssn!,
            "business_tax_id": b_ein!,
            "type": b_type!,
            "business_name": b_name!,
            "address": [
                "city": b_city!,
                "state": b_state!,
                "country": b_country!,
                "line1": b_line1!,
                "postal_code": b_postal_code!
            ]
        ]
        
        print(legalContent)
        
        let legalJSON: [String: AnyObject] = [
            "business_name": b_name!,
            "legal_entity" : legalContent
        ]

        User.saveProfile(dic) { (user, bool, err) in
            if bool == true {
                Account.saveStripeAccount(legalJSON) { (acct, bool, err) in
                    print("save acct called")
                    if bool == true {
                        self.showAlert("Profile Updated", color: UIColor.brandGreen(), image: UIImage(named: "ic_check_light")!)
                    } else {
                        self.showAlert((err?.localizedDescription)!, color: UIColor.brandRed(), image: UIImage(named: "ic_close_light")!)
                    }
                }
            } else {
                self.showAlert((err?.localizedDescription)!, color: UIColor.brandRed(), image: UIImage(named: "ic_close_light")!)
            }
        }
    }
    
    private func configure(user: User, account: Account) {
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
                
        let statusBarBackground = UIView()
        statusBarBackground.backgroundColor = UIColor.slateBlue()
        statusBarBackground.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 20)
        self.view.addSubview(statusBarBackground)
        
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height-3)
        tableView.contentInset.top = 80
        tableView.contentInset.bottom = 60
        tableView.contentOffset.y = 0
        tableView.backgroundColor = UIColor(rgba: "#efeff4")
        tableView.showsVerticalScrollIndicator = false
        
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 60)
        self.navigationController?.navigationBar.backgroundColor = UIColor.slateBlue()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationItem.title = "Edit Profile"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFontOfSize(14),
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
        
        let saveButton : UIBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EditProfileViewController.save(_:)))
        
        self.navigationItem.rightBarButtonItem = saveButton
        
        // Create RowFormers Personal Information
        
        let firstNameRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "First Name"
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .Words
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = user.first_name
                $0.text = Profile.sharedInstance.firstName
            }.onTextChanged {
                self.dic["first_name"] = $0
                Profile.sharedInstance.firstName = $0
        }
        let lastNameRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Last Name"
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .Words
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = user.last_name
                $0.text = Profile.sharedInstance.lastName
            }.onTextChanged {
                self.dic["last_name"] = $0
                Profile.sharedInstance.lastName = $0
        }
        let usernameRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Username"
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .None
            $0.textField.autocapitalizationType = UITextAutocapitalizationType.None
            $0.textField.autocorrectionType = UITextAutocorrectionType.No
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = user.username
                $0.text = Profile.sharedInstance.username
            }.onTextChanged {
                self.dic["username"] = $0
                Profile.sharedInstance.username = $0
        }
        let emailRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Email"
            $0.textField.keyboardType = .EmailAddress
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .None
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = user.email
                $0.text = Profile.sharedInstance.email
            }.onTextChanged {
                self.dic["email"] = $0
                Profile.sharedInstance.email = $0
        }
        let phoneRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Phone"
            $0.textField.keyboardType = .NumberPad
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = user.phone
                $0.text = Profile.sharedInstance.phoneNumber
            }.onTextChanged {
                self.dic["phone_number"] = $0
                Profile.sharedInstance.phoneNumber = $0
        }
        let birthdayRow = InlineDatePickerRowFormer<CustomLabelCell>(instantiateType: .Nib(nibName: "CustomLabelCell")) {
            $0.titleLabel.text = "Birthday"
            }.configure {
                $0.date = Profile.sharedInstance.birthDay ?? NSDate()
                $0.rowHeight = 60
            }.inlineCellSetup {
                $0.tintColor = UIColor.darkGrayColor()
                $0.datePicker.datePickerMode = .Date
            }.onDateChanged {
                self.dicLegalEntityDob["dob"] = String($0.timeIntervalSince1970)
                Profile.sharedInstance.birthDay = $0
        }
        let bioRow = TextViewRowFormer<FormTextViewCell>() { [weak self] in
//            $0.textView.textColor = .formerSubColor()
            $0.textView.font = UIFont(name: "Avenir-Light", size: 14)
            $0.textView.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = "Add your individual or company bio"
                $0.text = Profile.sharedInstance.introduction
            }.onTextChanged {
                self.dic["bio"] = $0
                Profile.sharedInstance.introduction = $0
        }
        
        // Create RowFormers Business information
        
        let businessName = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Busi Name"
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .Words
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = account.business_name
                $0.text = Profile.sharedInstance.businessName
            }.onTextChanged {
                NSUserDefaults.standardUserDefaults().setValue($0, forKey: "business_name")
                Profile.sharedInstance.businessName = $0
        }
        let businessAddressRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Address"
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .Words
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = account.address_line1
                $0.text = Profile.sharedInstance.businessAddressLine1
            }.onTextChanged {
                NSUserDefaults.standardUserDefaults().setValue($0, forKey: "line1")
                Profile.sharedInstance.businessAddressLine1 = $0
        }
        let businessAddressCountryRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Country"
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .Words
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = account.address_country
                $0.text = Profile.sharedInstance.businessAddressCountry
            }.onTextChanged {
                NSUserDefaults.standardUserDefaults().setValue($0, forKey: "country")
                Profile.sharedInstance.businessAddressCountry = $0
        }
        let businessAddressZipRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Postal Code"
            $0.textField.keyboardType = .NumberPad
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = account.address_postal_code
                $0.text = Profile.sharedInstance.businessAddressZip
            }.onTextChanged {
                NSUserDefaults.standardUserDefaults().setValue($0, forKey: "postal_code")
                Profile.sharedInstance.businessAddressZip = $0
        }
        let businessAddressCityRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "City"
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .Words
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = account.address_city
                $0.text = Profile.sharedInstance.businessAddressCity
            }.onTextChanged {
                NSUserDefaults.standardUserDefaults().setValue($0, forKey: "city")
                Profile.sharedInstance.businessAddressCity = $0
        }
        let businessAddressStateRow = InlinePickerRowFormer<CustomLabelCell, String>(instantiateType: .Nib(nibName: "CustomLabelCell")) {
            $0.titleLabel.text = "State"
            }.inlineCellSetup {
                $0.tintColor = UIColor.darkGrayColor()
            }.configure {
                $0.rowHeight = 60
                let businessStates = Profile.sharedInstance.state
                $0.pickerItems = businessStates.map {
                    InlinePickerItem(title: $0)
                }
                if let businessState = Profile.sharedInstance.businessAddressState {
                    $0.selectedRow = businessStates.indexOf(businessState)! //account.address_state ??
                }
            }.onValueChanged {
                NSUserDefaults.standardUserDefaults().setValue($0.title, forKey: "state")
                Profile.sharedInstance.businessAddressState = $0.title
        }
        let businessTypeRow = InlinePickerRowFormer<CustomLabelCell, String>(instantiateType: .Nib(nibName: "CustomLabelCell")) {
            $0.titleLabel.text = "Type"
            }.inlineCellSetup {
                $0.tintColor = UIColor.darkGrayColor()
            }.configure {
                $0.rowHeight = 60
                let businessTypes = ["individual", "company"]
                $0.pickerItems = businessTypes.map {
                    InlinePickerItem(title: $0)
                }
                if let businessType = Profile.sharedInstance.businessType {
                    $0.selectedRow = businessTypes.indexOf(businessType)! // account.type ?? 
                }
            }.onValueChanged {
                NSUserDefaults.standardUserDefaults().setValue($0.title, forKey: "type")
                Profile.sharedInstance.businessType = $0.title
        }
        let ssnRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "SSN Last 4"
            $0.textField.keyboardType = .NumberPad
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = account.ssn_last_4 ?? "XXXX For transfer volumes of $20,000+"
                $0.text = Profile.sharedInstance.ssn
            }.onTextChanged {
                NSUserDefaults.standardUserDefaults().setValue($0, forKey: "ssn_last_4")
                Profile.sharedInstance.ssn = $0
        }
        let einRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "EIN"
            $0.textField.keyboardType = .NumberPad
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = account.business_tax_id ?? "XX-XXXXXXX Business Tax ID"
                $0.text = Profile.sharedInstance.ein
            }.onTextChanged {
                NSUserDefaults.standardUserDefaults().setValue($0, forKey: "business_tax_id")
                Profile.sharedInstance.ein = $0
        }
        
        // Create Headers
        
        let createHeader: (String -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelHeaderView>()
                .configure {
                    $0.viewHeight = 40
                    $0.text = text
            }
        }
        
        // Create SectionFormers
        
        // Temporarily remove image section
        // let imageSection = SectionFormer(rowFormer: imageRow)
        //    .set(headerViewFormer: createHeader("Profile Image"))
        let profileSection = SectionFormer(rowFormer: firstNameRow, lastNameRow, usernameRow, emailRow, birthdayRow, phoneRow)
            .set(headerViewFormer: createHeader("Profile information"))
        let businessSection = SectionFormer(rowFormer: businessName, businessAddressRow, businessAddressCountryRow, businessAddressZipRow, businessAddressCityRow, businessAddressStateRow, businessTypeRow, ssnRow, einRow)
            .set(headerViewFormer: createHeader("Business information"))

        former.append(sectionFormer: profileSection, businessSection)
            .onCellSelected { [weak self] _ in
                self?.formerInputAccessoryView.update()
        }
    }
    
    private func showAlert(msg: String, color: UIColor, image: UIImage) {
        let customIcon:UIImage = image // your custom icon UIImage
        let customColor:UIColor = color // base color for the alert
        self.view.endEditing(true)
        let alertView = JSSAlertView().show(
            self,
            title: "",
            text: msg,
            buttonText: "Ok",
            noButtons: false,
            color: customColor,
            iconImage: customIcon)
        alertView.setTextTheme(.Light) // can be .Light or .Dark
    }
}