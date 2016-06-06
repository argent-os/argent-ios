//
//  MenuDetailViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 6/5/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import TransitionTreasury
import TransitionAnimation
import DKCircleButton
import Shimmer

class MenuDetailViewController: UIViewController, ModalTransitionDelegate {
    
    weak var modalDelegate: ModalViewControllerDelegate?
    
    var tr_presentTransition: TRViewControllerTransitionDelegate?

    @IBOutlet weak var backButton: UIButton!
    
    let swipeMenuSelectionLabel = UILabel()
    
    let swipeArrowImageView = UIImageView()
    
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    let screenHeight = UIScreen.mainScreen().bounds.size.height
    
    lazy var dismissGestureRecognizer: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.panDismiss(_:)))
        self.view.addGestureRecognizer(pan)
        return pan
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.offWhite()
        // Do any additional setup after loading the view.
        
        configureView()
    }
    
    func configureView() {
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        swipeArrowImageView.image = UIImage(named: "ic_arrow_up_gray")
        swipeArrowImageView.frame = CGRect(x: 0, y: screenHeight-55, width: screenWidth, height: 20) // shimmeringView.bounds
        swipeArrowImageView.contentMode = .ScaleAspectFit
        addSubviewWithFade(swipeArrowImageView, parentView: self, duration: 1)
        
        // view plans button
        let viewPlansButton = DKCircleButton()
        viewPlansButton.frame = CGRect(x: 30, y: 40, width: screenWidth/2-40, height: screenWidth/2-40)
        viewPlansButton.setBackgroundColor(UIColor.clearColor(), forState: .Normal)
        viewPlansButton.setBackgroundColor(UIColor.clearColor(), forState: .Highlighted)
        viewPlansButton.tintColor = UIColor.whiteColor()
        viewPlansButton.setTitleColor(UIColor.lightBlue(), forState: .Normal)
        viewPlansButton.setTitleColor(UIColor.lightBlue().colorWithAlphaComponent(0.5), forState: .Highlighted)
        viewPlansButton.titleLabel?.font = UIFont.systemFontOfSize(16, weight: UIFontWeightLight)
        viewPlansButton.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.5)
        viewPlansButton.borderSize = 1
        viewPlansButton.setTitle("Plans", forState: .Normal)
        viewPlansButton.clipsToBounds = true
        viewPlansButton.clipsToBounds = true
        viewPlansButton.addTarget(self, action: #selector(self.viewPlans(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        Timeout(0.1) {
            addSubviewWithBounce(viewPlansButton, parentView: self, duration: 0.3)
        }
        
        // view subscriptions button
        let viewSubscriptionsButton = DKCircleButton()
        viewSubscriptionsButton.frame = CGRect(x: screenWidth/2+20, y: 40, width: screenWidth/2-40, height: screenWidth/2-40)
        viewSubscriptionsButton.setBackgroundColor(UIColor.clearColor(), forState: .Normal)
        viewSubscriptionsButton.setBackgroundColor(UIColor.clearColor(), forState: .Highlighted)
        viewSubscriptionsButton.tintColor = UIColor.whiteColor()
        viewSubscriptionsButton.setTitleColor(UIColor.lightBlue(), forState: .Normal)
        viewSubscriptionsButton.setTitleColor(UIColor.lightBlue().colorWithAlphaComponent(0.5), forState: .Highlighted)
        viewSubscriptionsButton.titleLabel?.font = UIFont.systemFontOfSize(16, weight: UIFontWeightLight)
        viewSubscriptionsButton.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.5)
        viewSubscriptionsButton.borderSize = 1
        viewSubscriptionsButton.setTitle("Subscriptions", forState: .Normal)
        viewSubscriptionsButton.clipsToBounds = true
        viewSubscriptionsButton.addTarget(self, action: #selector(self.viewSubscriptions(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        Timeout(0.1) {
            addSubviewWithBounce(viewSubscriptionsButton, parentView: self, duration: 0.3)
        }
        
        // view customers button
        let viewCustomersButton = DKCircleButton()
        viewCustomersButton.frame = CGRect(x: 30, y: 40+20+screenWidth/2-20-10, width: screenWidth/2-40, height: screenWidth/2-40)
        viewCustomersButton.setBackgroundColor(UIColor.clearColor(), forState: .Normal)
        viewCustomersButton.setBackgroundColor(UIColor.clearColor(), forState: .Highlighted)
        viewCustomersButton.tintColor = UIColor.lightBlue()
        viewCustomersButton.setTitleColor(UIColor.lightBlue(), forState: .Normal)
        viewCustomersButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        viewCustomersButton.titleLabel?.font = UIFont.systemFontOfSize(16, weight: UIFontWeightLight)
        viewCustomersButton.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.3)
        viewCustomersButton.borderSize = 1
        viewCustomersButton.setTitle("Customers", forState: .Normal)
        viewCustomersButton.clipsToBounds = true
        viewCustomersButton.addTarget(self, action: #selector(self.viewCustomers(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        Timeout(0.3) {
            addSubviewWithBounce(viewCustomersButton, parentView: self, duration: 0.3)
        }

        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func viewCustomers(sender: AnyObject) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CustomersListTableViewController") as! CustomersListTableViewController
        tr_presentViewController(vc, method: TRPresentTransitionMethod.PopTip(visibleHeight: screenHeight*0.8), completion: {
            print("Present finished")
        })
    }
    
    func viewPlans(sender: AnyObject) {
        print("plans selected")
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PlansListTableViewController") as! PlansListTableViewController
        tr_presentViewController(vc, method: TRPresentTransitionMethod.PopTip(visibleHeight: screenHeight*0.8), completion: {
            print("Present finished")
        })
    }
    
    func viewSubscriptions(sender: AnyObject) {
        print("subscriptions selected")
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SubscriptionsListTableViewController") as! SubscriptionsListTableViewController
        tr_presentViewController(vc, method: TRPresentTransitionMethod.PopTip(visibleHeight: screenHeight*0.8), completion: {
            print("Present finished")
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func panDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Began :
            guard sender.translationInView(view).y < 0 else {
                break
            }
            modalDelegate?.modalViewControllerDismiss(interactive: true, callbackData: ["option":"none"])
        default : break
        }
    }
    
    deinit {
        print("Modal deinit.")
    }
    
}
