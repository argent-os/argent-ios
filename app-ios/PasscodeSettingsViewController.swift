//
//  PasscodeSettingsViewController.swift
//  PasscodeLockDemo
//
//  Created by Yanko Dimitrov on 8/29/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit
import PasscodeLock

class PasscodeSettingsViewController: UIViewController {

    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var superView: UIView!
    @IBOutlet weak var passcodeSwitch: UISwitch!
    @IBOutlet weak var changePasscodeButton: UIButton!
    
    private let configuration: PasscodeLockConfigurationType
    
    init(configuration: PasscodeLockConfigurationType) {
        
        self.configuration = configuration
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        let repository = UserDefaultsPasscodeRepository()
        configuration = PasscodeLockConfiguration(repository: repository)
        
        super.init(coder: aDecoder)
    }
    
    // MARK: - View
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = UIColor.whiteColor()
        
        updatePasscodeView()
    }
    
    override func viewDidLoad() {
        passcodeSwitch.onTintColor = UIColor(rgba: "#1f62f1")
        
        self.navigationController!.navigationBar.tintColor = UIColor.darkGrayColor()

        changePasscodeButton.layer.cornerRadius = 5
        changePasscodeButton.clipsToBounds = true
        changePasscodeButton.backgroundColor = UIColor(rgba: "#ffffff")
        
    }
    
    func updatePasscodeView() {
        
        let hasPasscode = configuration.repository.hasPasscode
        
        changePasscodeButton.hidden = !hasPasscode
        passcodeSwitch.on = hasPasscode
    }
    
    // MARK: - Actions
    
    @IBAction func passcodeSwitchValueChange(sender: AnyObject) {
        
        let passcodeVC: PasscodeLockViewController
        
        if passcodeSwitch.on {
            
            passcodeVC = PasscodeLockViewController(state: .SetPasscode, configuration: configuration)
            
        } else {
        
            passcodeVC = PasscodeLockViewController(state: .RemovePasscode, configuration: configuration)
            
            passcodeVC.successCallback = { lock in
                self.passcodeSwitch.on = !self.passcodeSwitch.on
                self.changePasscodeButton.hidden = true
                lock.repository.deletePasscode()
            }
        }

        presentViewController(passcodeVC, animated: true, completion: nil)
    }
    
    @IBAction func changePasscodeButtonTap(sender: AnyObject) {
        
        let repo = UserDefaultsPasscodeRepository()
        let config = PasscodeLockConfiguration(repository: repo)
        
        let passcodeLock = PasscodeLockViewController(state: .ChangePasscode, configuration: config)
        
        presentViewController(passcodeLock, animated: true, completion: nil)
    }
    
    //Changing Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    // This function is called before the segue, use this to make sure the view controller is properly returned to the root view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "homeView") {
            let rootViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("RootViewController"))! as UIViewController
            self.presentViewController(rootViewController, animated: true, completion: nil)
        }
    }
}