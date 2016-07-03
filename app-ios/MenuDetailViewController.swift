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
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissModal(_:)))
        swipeArrowImageView.addGestureRecognizer(tap)
        addSubviewWithFade(swipeArrowImageView, parentView: self, duration: 1)
        
        navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.blueColor()
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.lightBlue(),
            NSFontAttributeName: UIFont(name: "ArialRoundedMTBold", size: 16)!
        ]
        
        
        let viewCustomersImageView = UIImageView()
        viewCustomersImageView.backgroundColor = UIColor.whiteColor()
        viewCustomersImageView.layer.cornerRadius = 10
        viewCustomersImageView.frame = CGRect(x: 35, y: screenHeight*0.1, width: screenWidth-70, height: 120)
        viewCustomersImageView.contentMode = .ScaleAspectFit
        addSubviewWithShadow(UIColor.lightBlue(), radius: 10.0, offsetX: 0.0, offsetY: 0, opacity: 0.2, parentView: self, childView: viewCustomersImageView)
        
        let btn1 = CenteredButton()
        let str1 = NSAttributedString(string: "  View Customers", attributes: [
            NSForegroundColorAttributeName : UIColor.lightBlue(),
            NSFontAttributeName : UIFont.systemFontOfSize(17, weight: UIFontWeightRegular)
            ])
        btn1.setAttributedTitle(str1, forState: .Normal)
        btn1.setBackgroundColor(UIColor.offWhite(), forState: .Highlighted)
        btn1.frame = CGRect(x: 35, y: screenHeight*0.1, width: screenWidth-70, height: 120)
        btn1.setImage(UIImage(named: "IconRocket")?.alpha(0.5), forState: .Highlighted)
        btn1.layer.cornerRadius = 10
        btn1.layer.masksToBounds = true
        btn1.backgroundColor = UIColor.whiteColor()
        btn1.addTarget(self, action: #selector(self.viewCustomers(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(btn1)
        self.view.bringSubviewToFront(btn1)
        self.view.superview?.bringSubviewToFront(btn1)
        self.view.bringSubviewToFront(btn1)
        btn1.setImage(UIImage(named: "IconRocket"), inFrame: CGRectMake(18, 18, 64, 64), forState: .Normal)

        let viewSubscriptionsImageView = UIImageView()
        viewSubscriptionsImageView.backgroundColor = UIColor.whiteColor()
        viewSubscriptionsImageView.layer.cornerRadius = 10
        viewSubscriptionsImageView.frame = CGRect(x: 35, y: screenHeight*0.32, width: screenWidth-70, height: 120)
        viewSubscriptionsImageView.contentMode = .ScaleAspectFit
        addSubviewWithShadow(UIColor.lightBlue(), radius: 10.0, offsetX: 0.0, offsetY: 0, opacity: 0.2, parentView: self, childView: viewSubscriptionsImageView)
        
        let btn2 = CenteredButton()
        let str2 = NSAttributedString(string: "  View Subscriptions", attributes: [
            NSForegroundColorAttributeName : UIColor.lightBlue(),
            NSFontAttributeName : UIFont.systemFontOfSize(17, weight: UIFontWeightRegular)
            ])
        btn2.setAttributedTitle(str2, forState: .Normal)
        btn2.setBackgroundColor(UIColor.offWhite(), forState: .Highlighted)
        btn2.frame = CGRect(x: 35, y: screenHeight*0.32, width: screenWidth-70, height: 120)
        btn2.setImage(UIImage(named: "IconRuby")?.alpha(0.5), forState: .Highlighted)
        btn2.layer.cornerRadius = 10
        btn2.layer.masksToBounds = true
        btn2.backgroundColor = UIColor.whiteColor()
        btn2.addTarget(self, action: #selector(self.viewSubscriptions(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(btn2)
        self.view.bringSubviewToFront(btn2)
        self.view.superview?.bringSubviewToFront(btn2)
        self.view.bringSubviewToFront(btn2)
        btn2.setImage(UIImage(named: "IconRuby"), inFrame: CGRectMake(18, 18, 64, 64), forState: .Normal)

        let viewPlansImageView = UIImageView()
        viewPlansImageView.backgroundColor = UIColor.whiteColor()
        viewPlansImageView.layer.cornerRadius = 10
        viewPlansImageView.frame = CGRect(x: 35, y: screenHeight*0.54, width: screenWidth-70, height: 120)
        viewPlansImageView.contentMode = .ScaleAspectFit
        addSubviewWithShadow(UIColor.lightBlue(), radius: 10.0, offsetX: 0.0, offsetY: 0, opacity: 0.2, parentView: self, childView: viewPlansImageView)
        
        let btn3 = CenteredButton()
        let str3 = NSAttributedString(string: "  View Plans", attributes: [
            NSForegroundColorAttributeName : UIColor.lightBlue(),
            NSFontAttributeName : UIFont.systemFontOfSize(17, weight: UIFontWeightRegular)
            ])
        btn3.setAttributedTitle(str3, forState: .Normal)
        btn3.setBackgroundColor(UIColor.offWhite(), forState: .Highlighted)
        btn3.setImage(UIImage(named: "IconBulb")?.alpha(0.5), forState: .Highlighted)
        btn3.frame = CGRect(x: 35, y: screenHeight*0.54, width: screenWidth-70, height: 120)
        btn3.layer.cornerRadius = 10
        btn3.layer.masksToBounds = true
        btn3.backgroundColor = UIColor.whiteColor()
        btn3.addTarget(self, action: #selector(self.viewPlans(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(btn3)
        self.view.bringSubviewToFront(btn3)
        self.view.superview?.bringSubviewToFront(btn3)
        self.view.bringSubviewToFront(btn3)
        btn3.setImage(UIImage(named: "IconBulb"), inFrame: CGRectMake(18, 18, 64, 64), forState: .Normal)

        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func viewCustomers(sender: AnyObject) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CustomersListTableViewController") as! CustomersListTableViewController
        tr_presentViewController(vc, method: TRPresentTransitionMethod.Twitter, completion: {
            print("Present finished")
        })
    }
    
    func viewPlans(sender: AnyObject) {
        print("plans selected")
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PlansListTableViewController") as! PlansListTableViewController
        tr_presentViewController(vc, method: TRPresentTransitionMethod.Twitter, completion: {
            print("Present finished")
        })
    }
    
    func viewSubscriptions(sender: AnyObject) {
        print("subscriptions selected")
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SubscriptionsListTableViewController") as! SubscriptionsListTableViewController
        tr_presentViewController(vc, method: TRPresentTransitionMethod.Twitter, completion: {
            print("Present finished")
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissModal(sender: AnyObject) {
        modalDelegate?.modalViewControllerDismiss(interactive: true, callbackData: ["option":"none"])
    }
    
    func panDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Began :
            guard sender.velocityInView(view).y < 0 else {
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
