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
import MessageUI
final class EditProfileViewController: FormViewController, UINavigationBarDelegate, MFMailComposeViewControllerDelegate {
    
    var dic: Dictionary<String, AnyObject> = [:]

    var dicAccount: Dictionary<String, AnyObject> = [:]

    var dicAccountData: Dictionary<String, AnyObject> = [:]

    var dicLegalEntityAddress: Dictionary<String, AnyObject> = [:]

    var dicLegalEntityDob: Dictionary<String, AnyObject> = [:]

    var dicLegalEntityBusinessName: Dictionary<String, AnyObject> = [:]

    var dicLegalEntityType: Dictionary<String, AnyObject> = [:]

    let b_name = NSUserDefaults.standardUserDefaults().valueForKey("business_name") ?? ""
    let b_first_name = NSUserDefaults.standardUserDefaults().valueForKey("business_first_name") ?? ""
    let b_last_name = NSUserDefaults.standardUserDefaults().valueForKey("business_last_name") ?? ""
    let b_state = NSUserDefaults.standardUserDefaults().valueForKey("state") ?? ""
    let b_city = NSUserDefaults.standardUserDefaults().valueForKey("city") ?? ""
    let b_postal_code = NSUserDefaults.standardUserDefaults().valueForKey("postal_code") ?? ""
    let b_country = NSUserDefaults.standardUserDefaults().valueForKey("country") ?? ""
    let b_line1 = NSUserDefaults.standardUserDefaults().valueForKey("line1") ?? ""
    let b_ssn = NSUserDefaults.standardUserDefaults().valueForKey("ssn_last_4") ?? ""
    
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

    private func configure(user: User, account: Account) {
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
                
        let statusBarBackground = UIView()
        statusBarBackground.backgroundColor = UIColor.slateBlue()
        statusBarBackground.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 20)
        self.view.addSubview(statusBarBackground)
        
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height-3)
        tableView.contentInset.top = 40
        tableView.contentInset.bottom = 60
        tableView.contentOffset.y = 0
        tableView.backgroundColor = UIColor.offWhite()
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
                $0.placeholder = user.first_name ?? "Enter first name"
                $0.text = user.first_name ?? Profile.sharedInstance.firstName
                NSUserDefaults.standardUserDefaults().setValue($0.text, forKey: "b_first_name")
                self.dic["first_name"] = $0.text
            }.onTextChanged {
                self.dic["first_name"] = $0
                NSUserDefaults.standardUserDefaults().setValue($0, forKey: "b_first_name")
                Profile.sharedInstance.firstName = $0
        }
        let lastNameRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Last Name"
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .Words
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = user.last_name ?? "Enter last name"
                $0.text = user.last_name ?? Profile.sharedInstance.lastName
                NSUserDefaults.standardUserDefaults().setValue($0.text, forKey: "b_last_name")
                self.dic["last_name"] = $0.text
            }.onTextChanged {
                self.dic["last_name"] = $0
                NSUserDefaults.standardUserDefaults().setValue($0, forKey: "b_last_name")
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
                $0.placeholder = user.username ?? "Enter username"
                $0.text = user.username ?? Profile.sharedInstance.username
                self.dic["username"] = $0.text
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
                $0.placeholder = user.email ?? "Enter email"
                $0.text = user.email ?? Profile.sharedInstance.email
                self.dic["email"] = $0.text
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
                $0.placeholder = user.phone ?? "Enter phone number"
                $0.text = user.phone ?? Profile.sharedInstance.phoneNumber
                self.dic["phone_number"] = $0.text
            }.onTextChanged {
                self.dic["phone_number"] = $0
                Profile.sharedInstance.phoneNumber = $0
        }
//        let birthdayRow = InlineDatePickerRowFormer<CustomLabelCell>(instantiateType: .Nib(nibName: "CustomLabelCell")) {
//            $0.titleLabel.text = "Birthday"
//            }.configure {
//                $0.date = Profile.sharedInstance.birthDay ?? NSDate()
//                $0.rowHeight = 60
//            }.inlineCellSetup {
//                $0.tintColor = UIColor.darkGrayColor()
//                $0.datePicker.datePickerMode = .Date
//            }.onDateChanged {
//                self.dicLegalEntityDob["dob"] = String($0.timeIntervalSince1970)
//                Profile.sharedInstance.birthDay = $0
//        }
//        let bioRow = TextViewRowFormer<FormTextViewCell>() { [weak self] in
////            $0.textView.textColor = .formerSubColor()
//            $0.textView.font = UIFont(name: "HelveticaNeue-Light", size: 14)
//            $0.textView.inputAccessoryView = self?.formerInputAccessoryView
//            }.configure {
//                $0.rowHeight = 60
//                $0.placeholder = "Add your individual or company bio"
//                $0.text = Profile.sharedInstance.introduction
//            }.onTextChanged {
//                self.dic["bio"] = $0
//                Profile.sharedInstance.introduction = $0
//        }
        
        // Create RowFormers Business information
        
        let businessName = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Busi Name"
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .Words
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = account.business_name ?? "Enter business name"
                $0.text = account.business_name ?? Profile.sharedInstance.businessName
                NSUserDefaults.standardUserDefaults().setValue($0.text, forKey: "business_name")
                self.dic["business_name"] = $0.text
            }.onTextChanged {
                self.dic["business_name"] = $0
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
                $0.placeholder = account.address_line1 ?? "Enter business address"
                $0.text = account.address_line1 ?? Profile.sharedInstance.businessAddressLine1
                NSUserDefaults.standardUserDefaults().setValue($0.text, forKey: "line1")
            }.onTextChanged {
                NSUserDefaults.standardUserDefaults().setValue($0, forKey: "line1")
                Profile.sharedInstance.businessAddressLine1 = $0
        }
        let businessAddressCountryRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.userInteractionEnabled = false
            $0.titleLabel.text = "Country"
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .Words
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = account.address_country ?? "Business country"
                $0.text = account.address_country ?? Profile.sharedInstance.businessAddressCountry
                NSUserDefaults.standardUserDefaults().setValue($0.text, forKey: "country")
            }.onTextChanged {
//                NSUserDefaults.standardUserDefaults().setValue($0, forKey: "country")
                Profile.sharedInstance.businessAddressCountry = $0
        }
        let businessAddressZipRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Postal Code"
            $0.textField.keyboardType = .NumberPad
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = account.address_postal_code ?? "Enter business postal code"
                $0.text = account.address_postal_code ?? Profile.sharedInstance.businessAddressZip
                NSUserDefaults.standardUserDefaults().setValue($0.text, forKey: "postal_code")
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
                $0.placeholder = account.address_city ?? "Enter business city"
                $0.text = account.address_city ?? Profile.sharedInstance.businessAddressCity
                NSUserDefaults.standardUserDefaults().setValue($0.text, forKey: "city")
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
                if account.address_state != "" {
                    Profile.sharedInstance.businessAddressState = account.address_state
                    $0.selectedRow = businessStates.indexOf(account.address_state) ?? businessStates.indexOf("")!
                    NSUserDefaults.standardUserDefaults().setValue($0.selectedRow, forKey: "state")
                } else {
                }
            }.onValueChanged {
                NSUserDefaults.standardUserDefaults().setValue($0.title, forKey: "state")
                Profile.sharedInstance.businessAddressState = $0.title
        }
//        let businessTypeRow = InlinePickerRowFormer<CustomLabelCell, String>(instantiateType: .Nib(nibName: "CustomLabelCell")) {
//            $0.titleLabel.text = "Type"
//            }.inlineCellSetup {
//                $0.tintColor = UIColor.darkGrayColor()
//            }.configure {
//                $0.rowHeight = 60
//                let businessTypes = ["individual", "company"]
//                $0.pickerItems = businessTypes.map {
//                    InlinePickerItem(title: $0)
//                }
//                if let businessType = Profile.sharedInstance.businessType {
//                    $0.selectedRow = businessTypes.indexOf(businessType)! // account.type ?? 
//                }
//            }.onValueChanged {
//                NSUserDefaults.standardUserDefaults().setValue($0.title, forKey: "type")
//                Profile.sharedInstance.businessType = $0.title
//        }
        let ssnRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "SSN Last 4"
            $0.textField.keyboardType = .NumberPad
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                if account.ssn_last_4.toBool() == true {
                    $0.placeholder = "provided"
                } else {
                    $0.placeholder = "XXXX For transfers of $20,000+"
                }
                $0.text = Profile.sharedInstance.ssn
                NSUserDefaults.standardUserDefaults().setValue($0.text, forKey: "ssn_last_4")
            }.onTextChanged {
                NSUserDefaults.standardUserDefaults().setValue($0, forKey: "ssn_last_4")
                Profile.sharedInstance.ssn = $0
        }
//        let einRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
//            $0.titleLabel.text = "EIN"
//            $0.textField.keyboardType = .NumberPad
//            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
//            }.configure {
//                $0.rowHeight = 60
//                $0.placeholder = account.business_tax_id ?? "XX-XXXXXXX Business Tax ID"
//                $0.text = Profile.sharedInstance.ein
//            }.onTextChanged {
//                NSUserDefaults.standardUserDefaults().setValue($0, forKey: "business_tax_id")
//                Profile.sharedInstance.ein = $0
//        }
        let deleteRow = LabelRowFormer<FormLabelCell>() { [weak self] in
            if let sSelf = self {
                $0.backgroundColor = UIColor.brandRed()
                $0.titleLabel.textColor = UIColor.whiteColor()
                $0.titleLabel.font = .boldSystemFontOfSize(16)
                $0.tintColor = UIColor.whiteColor()
            }
            }.configure {
                $0.text = "Delete Account"
            }.onSelected { [weak self] _ in
                // show confirmation modal
                print("selected")
                let alertControllerCancel = UIAlertController(title: "Thanks!", message: "Thank you for choosing to stay with Argent.  If there is anything we can do to improve your user experience please let us know!  Send us a message at support@argent-tech.com", preferredStyle: UIAlertControllerStyle.Alert)
                
                let changeMindAction = UIAlertAction(title: "Ok", style: .Default) { (action) in
                    // send request to delete the bank account, on completion reload table data!
                    
                }
                alertControllerCancel.addAction(changeMindAction)
                
                ///////////
                let alertController = UIAlertController(title: "Confirm profile deletion", message: "Are you sure?  We'll be very sad to see you go!  Please let us know if we can make it up to you or if the app did not meet your requirements.", preferredStyle: UIAlertControllerStyle.Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) in
                    self!.presentViewController(alertControllerCancel, animated: true, completion: nil)
                })
                alertController.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "Continue", style: .Default) { (action) in
                    self?.sendEmailButtonTapped(self!)
                }
                alertController.addAction(OKAction)
                self!.presentViewController(alertController, animated: true, completion: nil)
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
        let profileSection = SectionFormer(rowFormer: firstNameRow, lastNameRow, usernameRow, emailRow, phoneRow)
            .set(headerViewFormer: createHeader("Profile information"))
        let businessSection = SectionFormer(rowFormer: businessName, businessAddressRow, businessAddressZipRow, businessAddressCityRow, businessAddressStateRow, ssnRow)
            .set(headerViewFormer: createHeader("Business information"))
        let deleteSection = SectionFormer(rowFormer: deleteRow)
            .set(headerViewFormer: createHeader("Delete account?"))
        
        former.append(sectionFormer: profileSection, businessSection, deleteSection)
            .onCellSelected { [weak self] _ in
                self?.formerInputAccessoryView.update()
        }
    }
    
    private func showAlert(title: String, msg: String, color: UIColor, image: UIImage) {
        let customIcon:UIImage = image // your custom icon UIImage
        let customColor:UIColor = color // base color for the alert
        self.view.endEditing(true)
        let alertView = JSSAlertView().show(
            self,
            title: title,
            text: msg,
            buttonText: "Ok",
            noButtons: false,
            color: customColor,
            iconImage: customIcon)
        alertView.setTextTheme(.Light) // can be .Light or .Dark
    }
}

extension EditProfileViewController {
    
    // Update Requests
    
    func save(sender: AnyObject) {
        if b_ssn?.stringValue == "" || b_ssn?.stringValue == nil {
            print("posting without ssn")
            postWithoutSSN()
        } else {
            print("posting with ssn")
            postWithSSN()
        }
    }
    
    func postWithSSN() {
        
        let legalContent: [String: AnyObject] = [
            "first_name": b_last_name!,
            "last_name": b_first_name!,
            "ssn_last_4": b_ssn!,
            "business_name": b_name!,
            "address": [
                "city": b_city!,
                "state": b_state!,
                "country": b_country!,
                "line1": b_line1!,
                "postal_code": b_postal_code!
            ]
        ]
        
        let legalJSON: [String: AnyObject] = [
            "business_name": b_name!,
            "legal_entity" : legalContent
        ]
        
        User.saveProfile(dic) { (user, bool, err) in
            if bool == true {
                Account.saveStripeAccount(legalJSON) { (acct, bool, err) in
                    print("save acct called")
                    if bool == true {
                        self.showAlert("Success", msg: "Profile Updated", color: UIColor.brandGreen(), image: UIImage(named: "ic_check_light")!)
                    } else {
                        self.showAlert("Error", msg: (err?.localizedDescription)!, color: UIColor.brandRed(), image: UIImage(named: "ic_close_light")!)
                    }
                }
            } else {
                self.showAlert("Error", msg: (err?.localizedDescription)!, color: UIColor.brandRed(), image: UIImage(named: "ic_close_light")!)
            }
        }
    }
    
    func postWithoutSSN() {
        let legalContent: [String: AnyObject] = [
            "first_name": b_last_name!,
            "last_name": b_first_name!,
            "business_name": b_name!,
            "address": [
                "city": b_city!,
                "state": b_state!,
                "country": b_country!,
                "line1": b_line1!,
                "postal_code": b_postal_code!
            ]
        ]
        
        let legalJSON: [String: AnyObject] = [
            "business_name": b_name!,
            "legal_entity" : legalContent
        ]
        
        User.saveProfile(dic) { (user, bool, err) in
            print("the dic is", self.dic)
            if bool == true {
                Account.saveStripeAccount(legalJSON) { (acct, bool, err) in
                    print("save acct called")
                    if bool == true {
                        self.showAlert("Success", msg: "Profile Updated", color: UIColor.brandGreen(), image: UIImage(named: "ic_check_light")!)
                    } else {
                        self.showAlert("Error", msg: (err?.localizedDescription)!, color: UIColor.brandRed(), image: UIImage(named: "ic_close_light")!)
                    }
                }
            } else {
                self.showAlert("Error", msg: (err?.localizedDescription)!, color: UIColor.brandRed(), image: UIImage(named: "ic_close_light")!)
            }
        }
    }
    
}

extension EditProfileViewController {
    
    // MARK: Email Composition
    
    @IBAction func sendEmailButtonTapped(sender: AnyObject) {
        let mailComposeViewController = self.configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([])
        User.getProfile { (user, err) in
            mailComposerVC.setToRecipients(["support@argent-tech.com"])
            mailComposerVC.setSubject(APP_NAME + " User Deletion | @" + (user?.username)!)
            mailComposerVC.setMessageBody("I would like to delete my Argent account.", isHTML: false)
        }
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .Alert)
        sendMailErrorAlert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
        
}