//
//  ParallaxHeader.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 4/28/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit

class ParallaxHeaderView: UIView {
    
    var heightLayoutConstraint = NSLayoutConstraint()
    var bottomLayoutConstraint = NSLayoutConstraint()
    
    var containerView = UIView()
    var containerLayoutConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightBlue()
        
        // The container view is needed to extend the visible area for the image view
        // to include that below the navigation bar. If this container view isn't present
        // the image view would be clipped at the navigation bar's bottom and the parallax
        // effect would not work correctly
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.lightBlue()
        self.addSubview(containerView)
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[containerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["containerView" : containerView]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[containerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["containerView" : containerView]))
        containerLayoutConstraint = NSLayoutConstraint(item: containerView, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 1.0, constant: 0.0)
        self.addConstraint(containerLayoutConstraint)
        
        let imageView: UIImageView = UIImageView.init()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .ScaleAspectFill

        self.containerView.backgroundColor = UIColor.paleBlue()

        User.getProfile({ (user, error) in
            if user?.picture != nil && user?.picture != "" {
                let img = UIImage(data: NSData(contentsOfURL: NSURL(string: (user?.picture)!)!)!)!
                imageView.image = img
                
                // Blurview
                let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
                visualEffectView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
                
                self.containerView.addSubview(imageView)
                imageView.addSubview(visualEffectView)
                
                self.containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[imageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["imageView" : imageView]))
                self.bottomLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: .Bottom, relatedBy: .Equal, toItem: self.containerView, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
                self.containerView.addConstraint(self.bottomLayoutConstraint)
                self.heightLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: .Height, relatedBy: .Equal, toItem: self.containerView, attribute: .Height, multiplier: 1.0, constant: 0.0)
                self.containerView.addConstraint(self.heightLayoutConstraint)
            } else {
                let img = UIImage(named: "BackgroundGradientCalmBlue")
                imageView.image = img

                self.containerView.addSubview(imageView)
                
                self.containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[imageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["imageView" : imageView]))
                self.bottomLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: .Bottom, relatedBy: .Equal, toItem: self.containerView, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
                self.containerView.addConstraint(self.bottomLayoutConstraint)
                self.heightLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: .Height, relatedBy: .Equal, toItem: self.containerView, attribute: .Height, multiplier: 1.0, constant: 0.0)
                self.containerView.addConstraint(self.heightLayoutConstraint)
            }
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        containerLayoutConstraint.constant = scrollView.contentInset.top;
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top);
        containerView.clipsToBounds = offsetY <= 0
        bottomLayoutConstraint.constant = offsetY >= 0 ? 0 : -offsetY / 2
        heightLayoutConstraint.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
    }
}
