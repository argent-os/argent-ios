//
//  OnboardingViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/12/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import Crashlytics

class OnboardingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    
    @IBOutlet weak var onboardingPageControl: UIPageControl!
    
    var onboardingSkipButton = UIButton()
        
    var onboardingBackgroundScrollView: UIScrollView!
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        configureView()
    }
    
    func configureView() {
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        
        self.onboardingCollectionView.delegate = self
        self.onboardingCollectionView.dataSource = self
        
        // Register cells
        
        // Background view setup
        let backgroundImage: UIImage! = UIImage(named: "BackgroundBusinessBlurDark")
        let backgroundImageView: UIImageView! = UIImageView(image: backgroundImage)
        backgroundImageView.frame = CGRectMake(0.0, 0.0, backgroundImageView.frame.size.width+500, self.view.frame.size.height)
        
        // Set scroll view frame to the size of the image
        self.onboardingBackgroundScrollView = UIScrollView(frame: self.view.frame)
        self.onboardingBackgroundScrollView.addSubview(backgroundImageView)
        self.onboardingBackgroundScrollView.contentSize = backgroundImage.size
        self.onboardingBackgroundScrollView.userInteractionEnabled = false
        self.onboardingBackgroundScrollView.showsHorizontalScrollIndicator = false
        self.onboardingBackgroundScrollView.showsVerticalScrollIndicator = false
        
        // Set origin and height of scroll view to devivice-specific values
        self.onboardingBackgroundScrollView.frame = CGRectMake(0.0, 0.0, self.onboardingBackgroundScrollView.frame.size.width, self.onboardingBackgroundScrollView.frame.size.height)
        
        self.view.addSubview(self.onboardingBackgroundScrollView)
        self.view.sendSubviewToBack(self.onboardingBackgroundScrollView)
        
        onboardingSkipButton.frame = CGRect(x: screenWidth-70, y: 10, width: 70, height: 50)
        onboardingSkipButton.setTitle("Skip", forState: .Normal)
        onboardingSkipButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        onboardingSkipButton.setTitleColor(UIColor.whiteColor().colorWithAlphaComponent(0.5), forState: .Highlighted)
        onboardingSkipButton.tintColor = UIColor.whiteColor()
        onboardingSkipButton.addTarget(self, action: #selector(self.skipOnboarding(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(onboardingSkipButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        Answers.logCustomEventWithName("Features Page Opened",
                                       customAttributes: [:])
    }
    
    @IBAction func skipOnboarding(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("kDismissOnboardingNotification", object: self)
    }
}

// MARK: UICollectionViewDelelgate Methods

extension OnboardingViewController {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let _: UICollectionViewCell
        // let width = self.view.layer.frame.width
        // let height = self.view.layer.frame.height
        switch indexPath.row {
        case 0:
            // TODO: cell 1
            if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("onboardingCell", forIndexPath: indexPath) as? OnboardingCollectionViewCell {
                cell.contentImage.image = UIImage(named: "IconIntroRecurring")
                
                cell.contentDescriptionLabel.text = APP_NAME + " allows businesses to create services plans for their customers to control recurring payments over a custom time interval. Take the pain out of getting paid and let our app do the work for you. Set up a payment plan and start getting paid today!"
                cell.contentDescriptionLabel.font = UIFont(name: "MyriadPro-Regular", size: 16)
                cell.contentDescriptionLabel.lineBreakMode = .ByWordWrapping
                cell.contentDescriptionLabel.numberOfLines = 7
                cell.contentDescriptionLabel.textAlignment = .Center
                cell.contentDescriptionLabel.alpha = 1

                cell.contentLabel.text = "Recurring payments"
                cell.contentLabel.font = UIFont(name: "MyriadPro-Regular", size: 24)
                cell.contentLabel.alpha = 0.9
                cell.contentLabel.textColor = UIColor.whiteColor()
                cell.getStartedButton.hidden = true
                return cell
            }
            
        case 1:
            // TODO: cell 2
            if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("onboardingCell", forIndexPath: indexPath) as? OnboardingCollectionViewCell {
                cell.contentImage.image = UIImage(named: "IconIntroBitcoin")
                
                cell.contentDescriptionLabel.text = APP_NAME + " provides a POS (Point of Sale) solution for businesses to accept Bitcoin. We convert Bitcoin into USD with the real-time exchange rate and automatically initiate a transfer into the bank account of your choice."
                cell.contentDescriptionLabel.font = UIFont(name: "MyriadPro-Regular", size: 16)
                cell.contentDescriptionLabel.lineBreakMode = .ByWordWrapping
                cell.contentDescriptionLabel.numberOfLines = 7
                cell.contentDescriptionLabel.textAlignment = .Center
                cell.contentDescriptionLabel.alpha = 1

                cell.contentLabel.text = "Accept Bitcoin"
                cell.contentLabel.font = UIFont(name: "MyriadPro-Regular", size: 24)
                cell.contentLabel.alpha = 0.9
                cell.contentLabel.textColor = UIColor.whiteColor()
                cell.getStartedButton.hidden = true
                return cell
            }
            
        case 2:
            if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("onboardingCell", forIndexPath: indexPath) as? OnboardingCollectionViewCell {
                cell.getStartedButton.layer.cornerRadius = 5
                cell.getStartedButton.layer.masksToBounds = true
                cell.getStartedButton.backgroundColor = UIColor.whiteColor()
                cell.getStartedButton.setTitleColor(UIColor.lightBlue(), forState: .Normal)
                cell.getStartedButton.setTitleColor(UIColor.darkBlue(), forState: .Highlighted)
                
                cell.contentImage.image = UIImage(named: "IconIntroTouch")
                
                cell.contentDescriptionLabel.text = APP_NAME + " enables users to utilize Apple Pay to process secured payments for performed services.  We enable both peer-to-peer as well as peer-to-merchant payments with a single touch."
                cell.contentDescriptionLabel.font = UIFont(name: "MyriadPro-Regular", size: 16)
                cell.contentDescriptionLabel.lineBreakMode = .ByWordWrapping
                cell.contentDescriptionLabel.numberOfLines = 7
                cell.contentDescriptionLabel.textAlignment = .Center
                cell.contentDescriptionLabel.alpha = 1
                
                cell.contentLabel.text = "Apple Pay Integration"
                cell.contentLabel.font = UIFont(name: "MyriadPro-Regular", size: 24)
                cell.contentLabel.alpha = 0.9
                cell.contentLabel.textColor = UIColor.whiteColor()
                cell.getStartedButton.hidden = false
                return cell
            }
            
        default:
            if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("onboardingCell", forIndexPath: indexPath) as? OnboardingCollectionViewCell {
                cell.contentLabel.text = "Default"
                cell.getStartedButton.hidden = true
                return cell
            }
        }
        
        return UICollectionViewCell() // FIXME: Better error silencing
    }
}

// MARK: UICollectionViewFlowLayout Methods

extension OnboardingViewController {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(self.onboardingCollectionView.frame.size.width, self.onboardingCollectionView.frame.size.height)
    }
}

// MARK: UIScrollVewDelegate for UIPageControl

extension OnboardingViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (scrollView.isKindOfClass(UICollectionView)) {
            // calculate percentage of scrolling
            // scroll backgroundScrollView that percentage
            
            // returns the percent of the onboarding collection view scrolled as a decimal
            let percentScrolled: CGFloat! = fabs(scrollView.contentOffset.x / scrollView.contentSize.width)
            
            self.onboardingBackgroundScrollView.setContentOffset(CGPointMake(self.onboardingBackgroundScrollView.contentSize.width * percentScrolled, 0.0), animated: false)
            
            // Fade out page control and skip button on last cell
            // Funky calculations ahead
            
            let numSwipes = 1.0 // number of swipes until we start to fade
            let offset = self.view.frame.size.width * CGFloat(numSwipes) // offset of fade start
            
            if(self.onboardingCollectionView.contentOffset.x == 0) {
                onboardingPageControl.currentPage = 0
            } else {
                onboardingPageControl.currentPage = 1
            }
            
            if (self.onboardingCollectionView.contentOffset.x > offset) {
                // this caluclates the value between the 3rd and 4th cell to be a decimal between 1 and 0 to use for fading out some UI elements
                let min = self.view.frame.size.width * 1; // start fade here, alpha should be 1
                let max = self.view.frame.size.width * 2; // end fade here, alpha should be 0
                
                let alpha = (1 - (self.onboardingCollectionView.contentOffset.x - min) / (max - min));
                self.onboardingPageControl.alpha = alpha
                self.onboardingSkipButton.alpha = alpha
            }
        }
    }
}

