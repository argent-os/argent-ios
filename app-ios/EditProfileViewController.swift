//
//  EditProfileViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/18/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit
import Former

final class EditProfileViewController: FormViewController {
    
    // MARK: Public
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
        super.viewDidLoad()
        configure()
    }
    
    // MARK: Private
    
    private lazy var formerInputAccessoryView: FormerInputAccessoryView = FormerInputAccessoryView(former: self.former)
    
    private lazy var imageRow: LabelRowFormer<ProfileImageCell> = {
        LabelRowFormer<ProfileImageCell>(instantiateType: .Nib(nibName: "ProfileImageCell")) {
            $0.iconView.image = Profile.sharedInstance.image
            }.configure {
                $0.text = "Choose profile image from library"
                $0.rowHeight = 60
            }.onSelected { [weak self] _ in
                self?.former.deselect(true)
                self?.presentImagePicker()
        }
    }()
    
    private lazy var informationSection: SectionFormer = {
        let ssnRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "SSN Last 4"
            $0.textField.keyboardType = .NumberPad
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = "For transfer volumes of $20,000+"
                $0.text = Profile.sharedInstance.ssn
            }.onTextChanged {
                Profile.sharedInstance.ssn = $0
        }
        let businessName = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Business Name"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = ""
                $0.text = Profile.sharedInstance.businessName
            }.onTextChanged {
                Profile.sharedInstance.businessName = $0
        }
        let businessAddressRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Address"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = ""
                $0.text = Profile.sharedInstance.businessAddressLine1
            }.onTextChanged {
                Profile.sharedInstance.businessAddressLine1 = $0
        }
        let businessAddressCountryRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Country"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = ""
                $0.text = Profile.sharedInstance.businessAddressCountry
            }.onTextChanged {
                Profile.sharedInstance.businessAddressCountry = $0
        }
        let businessAddressZipRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "ZIP"
            $0.textField.keyboardType = .NumberPad
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = ""
                $0.text = Profile.sharedInstance.businessAddressZip
            }.onTextChanged {
                Profile.sharedInstance.businessAddressZip = $0
        }
        let businessAddressCityRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "City"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = ""
                $0.text = Profile.sharedInstance.businessAddressCity
            }.onTextChanged {
                Profile.sharedInstance.businessAddressCity = $0
        }
        let businessAddressStateRow = InlinePickerRowFormer<ProfileLabelCell, String>(instantiateType: .Nib(nibName: "ProfileLabelCell")) {
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
                    $0.selectedRow = businessStates.indexOf(businessState) ?? 0
                }
            }.onValueChanged {
                Profile.sharedInstance.businessAddressState = $0.title
        }
        let businessTypeRow = InlinePickerRowFormer<ProfileLabelCell, String>(instantiateType: .Nib(nibName: "ProfileLabelCell")) {
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
                    $0.selectedRow = businessTypes.indexOf(businessType) ?? 0
                }
            }.onValueChanged {
                Profile.sharedInstance.businessType = $0.title
        }
        return SectionFormer(rowFormer: businessName, businessAddressRow, businessAddressCountryRow, businessAddressZipRow, businessAddressCityRow, businessAddressStateRow, businessTypeRow, ssnRow)
    }()
    
    private func configure() {
        tableView.frame = CGRect(x: 0, y: 80, width: self.view.bounds.width, height: self.view.bounds.height-80)
        tableView.contentInset.top = 0
        tableView.contentInset.bottom = 40
        tableView.contentOffset.y = 20
        tableView.backgroundColor = UIColor.whiteColor()

        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 65))
        navBar.barTintColor = UIColor.mediumBlue()
        navBar.tintColor = UIColor.darkGrayColor()
        navBar.translucent = false
        navBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "Avenir-Light", size: 18)!
        ]
        self.view.addSubview(navBar);
        let navItem = UINavigationItem(title: "Edit Profile");
        navBar.setItems([navItem], animated: false);
        
        // Create RowFomers
        
        let firstNameRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "First Name"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = ""
                $0.text = Profile.sharedInstance.firstName
            }.onTextChanged {
                Profile.sharedInstance.firstName = $0
        }
        let lastNameRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Last Name"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = ""
                $0.text = Profile.sharedInstance.lastName
            }.onTextChanged {
                Profile.sharedInstance.lastName = $0
        }
        let usernameRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Username"
            $0.textField.autocapitalizationType = UITextAutocapitalizationType.None
            $0.textField.autocorrectionType = UITextAutocorrectionType.No
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = ""
                $0.text = Profile.sharedInstance.username
            }.onTextChanged {
                Profile.sharedInstance.username = $0
        }
        let emailRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Email"
            $0.textField.keyboardType = .EmailAddress
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = ""
                $0.text = Profile.sharedInstance.email
            }.onTextChanged {
                Profile.sharedInstance.email = $0
        }
        let phoneRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Phone"
            $0.textField.keyboardType = .NumberPad
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = ""
                $0.text = Profile.sharedInstance.phoneNumber
            }.onTextChanged {
                Profile.sharedInstance.phoneNumber = $0
        }
        let birthdayRow = InlineDatePickerRowFormer<ProfileLabelCell>(instantiateType: .Nib(nibName: "ProfileLabelCell")) {
            $0.titleLabel.text = "Birthday"
            }.configure {
                $0.date = Profile.sharedInstance.birthDay ?? NSDate()
                $0.rowHeight = 60
            }.inlineCellSetup {
                $0.tintColor = UIColor.darkGrayColor()
                $0.datePicker.datePickerMode = .Date
            }.onDateChanged {
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
                Profile.sharedInstance.introduction = $0
        }
        let moreRow = SwitchRowFormer<FormSwitchCell>() {
            $0.titleLabel.text = "Enable higher limit transfer volumes?"
            $0.titleLabel.textColor = UIColor.darkGrayColor()
            $0.titleLabel.font = UIFont(name: "Avenir-Light", size: 14)
//            $0.switchButton.onTintColor = .formerSubColor()
            }.configure {
                $0.rowHeight = 60
                $0.switched = Profile.sharedInstance.moreInformation
                $0.switchWhenSelected = true
            }.onSwitchChanged { [weak self] in
                Profile.sharedInstance.moreInformation = $0
                self?.switchInfomationSection()
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
        
        let imageSection = SectionFormer(rowFormer: imageRow)
            .set(headerViewFormer: createHeader("Profile Image"))
        let aboutSection = SectionFormer(rowFormer: firstNameRow, lastNameRow, usernameRow, emailRow, birthdayRow, phoneRow)
            .set(headerViewFormer: createHeader("Profile information"))
        let moreSection = SectionFormer(rowFormer: moreRow)
            .set(headerViewFormer: createHeader("Additional transfer-enabling security infomation"))
        
        former.append(sectionFormer: imageSection, aboutSection, moreSection)
            .onCellSelected { [weak self] _ in
                self?.formerInputAccessoryView.update()
        }
        if Profile.sharedInstance.moreInformation {
            former.append(sectionFormer: informationSection)
        }
    }
    
    private func presentImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        picker.allowsEditing = false
        presentViewController(picker, animated: true, completion: nil)
    }
    
    private func switchInfomationSection() {
        if Profile.sharedInstance.moreInformation {
            former.insertUpdate(sectionFormer: informationSection, toSection: former.numberOfSections, rowAnimation: .Top)
        } else {
            former.removeUpdate(sectionFormer: informationSection, rowAnimation: .Top)
        }
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        Profile.sharedInstance.image = image
        imageRow.cellUpdate {
            $0.iconView.image = image
        }
    }
}