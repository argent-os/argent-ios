//
//  OnboardingViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/12/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit

class OnboardingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    
    @IBOutlet weak var onboardingPageControl: UIPageControl!
    
    @IBOutlet weak var onboardingSkipButton: UIButton!
    
    var onboardingBackgroundScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.onboardingCollectionView.delegate = self
        self.onboardingCollectionView.dataSource = self
        
        // Register cells
        
        // Background view setup
        let backgroundImage: UIImage! = UIImage(named: "BackgroundOnboarding")
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        switch indexPath.row {
        case 0:
            // TODO: cell 1
            if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("onboardingCell", forIndexPath: indexPath) as? OnboardingCollectionViewCell {
                cell.contentLabel.text = "1"
                cell.contentLabel.textColor = UIColor.whiteColor()
                cell.getStartedButton.hidden = true
                return cell
            }
            
        case 1:
            // TODO: cell 2
            if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("onboardingCell", forIndexPath: indexPath) as? OnboardingCollectionViewCell {
                cell.contentLabel.text = "2"
                cell.contentLabel.textColor = UIColor.whiteColor()
                cell.getStartedButton.hidden = true
                return cell
            }
            
        case 2:
            if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("onboardingCell", forIndexPath: indexPath) as? OnboardingCollectionViewCell {
                cell.contentLabel.text = "3"
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
            
            if (self.onboardingCollectionView.contentOffset.x > offset) {
                // this caluclates the value between the 3rd and 4th cell to be a decimal between 1 and 0 to use for fading out some UI elements
                let min = self.view.frame.size.width * 1; // start fade here, alpha should be 1
                let max = self.view.frame.size.width * 2; // end fade here, alpha should be 0
                
                let alpha = (1 - (self.onboardingCollectionView.contentOffset.x - min) / (max - min));
                self.onboardingPageControl.alpha = alpha
                self.onboardingSkipButton.alpha = alpha
                self.onboardingSkipButton.frame = CGRect(x: -20, y: 20, width: 100, height: 100)
            }
        }
    }
}

