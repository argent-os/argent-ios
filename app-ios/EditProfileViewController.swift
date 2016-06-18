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

    var b_name = NSUserDefaults.standardUserDefaults().valueForKey("business_name") ?? ""
    var b_email = NSUserDefaults.standardUserDefaults().valueForKey("business_email") ?? ""
    var b_first_name = NSUserDefaults.standardUserDefaults().valueForKey("business_first_name") ?? ""
    var b_last_name = NSUserDefaults.standardUserDefaults().valueForKey("business_last_name") ?? ""
    var b_state = NSUserDefaults.standardUserDefaults().valueForKey("state") ?? ""
    var b_city = NSUserDefaults.standardUserDefaults().valueForKey("city") ?? ""
    var b_postal_code = NSUserDefaults.standardUserDefaults().valueForKey("postal_code") ?? ""
    var b_country = NSUserDefaults.standardUserDefaults().valueForKey("country") ?? ""
    var b_line1 = NSUserDefaults.standardUserDefaults().valueForKey("line1") ?? ""
    var b_ssn = NSUserDefaults.standardUserDefaults().valueForKey("ssn_last_4") ?? ""
    var b_ein = NSUserDefaults.standardUserDefaults().valueForKey("ein") ?? ""
    
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
                $0.placeholder = account.business_first_name ?? "Enter first name"
                $0.text = account.business_first_name ?? Profile.sharedInstance.firstName
                b_first_name = $0.text
                self.dic["first_name"] = $0.text
            }.onTextChanged {
                self.dic["first_name"] = $0
                self.b_first_name = $0
                Profile.sharedInstance.firstName = $0
        }
        let lastNameRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Last Name"
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .Words
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = account.business_last_name ?? "Enter last name"
                $0.text = account.business_last_name ?? Profile.sharedInstance.lastName
                b_last_name = $0.text
                self.dic["last_name"] = $0.text
            }.onTextChanged {
                self.dic["last_name"] = $0
                self.b_last_name = $0
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
                $0.placeholder = account.business_email ?? "Enter email"
                $0.text = account.business_email ?? Profile.sharedInstance.email
                b_email = $0.text
                self.dic["email"] = $0.text
            }.onTextChanged {
                self.dic["email"] = $0
                self.b_email = $0
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
                b_name = $0.text
                self.dic["business_name"] = $0.text
            }.onTextChanged {
                self.dic["business_name"] = $0
                self.b_name = $0
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
                b_line1 = $0.text
            }.onTextChanged {
                self.b_line1 = $0
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
                b_country = $0.text
                NSUserDefaults.standardUserDefaults().setValue($0.text, forKey: "country")
            }.onTextChanged {
//                NSUserDefaults.standardUserDefaults().setValue($0, forKey: "country")
                self.b_country = $0
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
                b_postal_code = $0.text
            }.onTextChanged {
                self.b_postal_code = $0
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
                b_city = $0.text
            }.onTextChanged {
                self.b_city = $0
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
                    $0.selectedRow = businessStates.indexOf(account.address_state)!
                    b_state = account.address_state
                    NSUserDefaults.standardUserDefaults().setValue(account.address_state, forKey: "state")
                } else {
                    $0.selectedRow = businessStates.indexOf("")!
                    NSUserDefaults.standardUserDefaults().setValue("", forKey: "state")
                }
            }.onValueChanged {
                self.b_state = $0.title
                NSUserDefaults.standardUserDefaults().setValue($0.title, forKey: "state")
                Profile.sharedInstance.businessAddressState = $0.title
        }

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
        
        let einRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "EIN"
            $0.textField.keyboardType = .NumberPad
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                if account.ein != "" {
                    $0.placeholder = "provided"
                } else {
                    $0.placeholder = "Employee Identification Number"
                }
                $0.text = Profile.sharedInstance.ein
                b_ein = $0.text
                NSUserDefaults.standardUserDefaults().setValue($0.text, forKey: "ein")
            }.onTextChanged {
                self.b_ein = $0
                NSUserDefaults.standardUserDefaults().setValue($0, forKey: "ein")
                Profile.sharedInstance.ein = $0
        }

        let saveRow = LabelRowFormer<FormLabelCell>() { [weak self] in
            if let x = self {
                $0.backgroundColor = UIColor.skyBlue()
                $0.titleLabel.textColor = UIColor.whiteColor()
                $0.titleLabel.font = .boldSystemFontOfSize(16)
                $0.tintColor = UIColor.whiteColor()
            }
            }.configure {
                $0.text = "Save Profile"
            }.onSelected { [weak self] _ in
                if let x = self {
                    x.save(x)
                }
        }
        
        let deleteRow = LabelRowFormer<FormLabelCell>() { [weak self] in
                if let x = self {
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
        let businessSection = SectionFormer(rowFormer: businessName, businessAddressRow, businessAddressZipRow, businessAddressCityRow, businessAddressStateRow, ssnRow, einRow)
            .set(headerViewFormer: createHeader("Business information"))
        let saveSection = SectionFormer(rowFormer: saveRow)
        let deleteSection = SectionFormer(rowFormer: deleteRow)
            .set(headerViewFormer: createHeader("Delete account?"))
        
        former.append(sectionFormer: profileSection, businessSection, saveSection, deleteSection)
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
        print(b_ssn)
        if b_ssn?.stringValue == "" || b_ssn!.stringValue == nil {
            print("posting without ssn")
            postWithoutSSN()
        } else {
            print("posting with ssn")
            postWithSSN()
        }
        Account.getStripeAccount { (acct, err) in
            if acct?.business_first_name == "" {
                Account.saveStripeAccount(
                    [ "legal_entity":
                        [
                            "first_name": self.b_first_name!
                        ]
                    ]) { (acct, bool, err) in
                }
            }
            if acct?.business_last_name == "" {
                Account.saveStripeAccount(
                    [ "legal_entity":
                        [
                            "first_name": self.b_first_name!
                        ]
                ]) { (acct, bool, err) in
                }
            }
            if acct?.ein == "" {
                Account.saveStripeAccount(
                    [ "legal_entity":
                        [
                            "business_tax_id": self.b_ein!
                        ]
                ]) { (acct, bool, err) in
                }
            }
        }
    }
    
    func postWithSSN() {
        
        let legalContent: [String: AnyObject] = [
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
            "email": b_email!,
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
            "email": b_email!,            
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