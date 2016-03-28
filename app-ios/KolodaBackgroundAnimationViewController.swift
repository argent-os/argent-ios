//
//  BackgroundAnimationViewController.swift
//  Koloda
//
//  Created by Eugene Andreyev on 7/11/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import Koloda
import pop

private let numberOfCards: UInt = 5
private let frameAnimationSpringBounciness:CGFloat = 5
private let frameAnimationSpringSpeed:CGFloat = 3
private let kolodaCountOfVisibleCards = 2
// sets background alpha opacity
private let kolodaAlphaValueSemiTransparent:CGFloat = 0.0

class BackgroundAnimationViewController: UIViewController {
    
    @IBOutlet weak var kolodaView: CustomKolodaView!
    
    //Changing Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Transparent navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        kolodaView.delegate = self
        kolodaView.dataSource = self
        self.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
    }
    
    
    //MARK: IBActions
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(SwipeResultDirection.Left)
    }
    
    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(SwipeResultDirection.Right)
    }
    
    @IBAction func undoButtonTapped() {
        kolodaView?.revertAction()
    }
}

//MARK: KolodaViewDelegate
extension BackgroundAnimationViewController: KolodaViewDelegate {
    func koloda(kolodaDidRunOutOfCards koloda: KolodaView) {
        //Example: reloading
        kolodaView.resetCurrentCardNumber()
    }
    
    func koloda(koloda: KolodaView, didSelectCardAtIndex index: UInt) {
//        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.protonpayments.com")!)
    }
    
    func koloda(kolodaShouldApplyAppearAnimation koloda: KolodaView) -> Bool {
        return true
    }
    
    func koloda(kolodaShouldMoveBackgroundCard koloda: KolodaView) -> Bool {
        return false
    }
    
    func koloda(kolodaShouldTransparentizeNextCard koloda: KolodaView) -> Bool {
        return true
    }
    
    func koloda(kolodaBackgroundCardAnimation koloda: KolodaView) -> POPPropertyAnimation? {
        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        animation.springBounciness = frameAnimationSpringBounciness
        animation.springSpeed = frameAnimationSpringSpeed
        return animation
    }
}

// screen width and height:
let width = UIScreen.mainScreen().bounds.size.width
let height = UIScreen.mainScreen().bounds.size.height

// Padding for paragraph
var initialFrame: CGRect = CGRectMake(0, height*0.45, width, 100)
var contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 50)
var paddedFrame: CGRect = UIEdgeInsetsInsetRect(initialFrame, contentInsets)
var initialFrameImage: CGRect = CGRectMake(0, height*0.18, width, 90)
var contentInsetsImage: UIEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 50)
var paddedFrameImage: CGRect = UIEdgeInsetsInsetRect(initialFrameImage, contentInsetsImage)

//MARK: KolodaViewDataSource
extension BackgroundAnimationViewController: KolodaViewDataSource {
    
    func koloda(kolodaNumberOfCards koloda:KolodaView) -> UInt {
        return numberOfCards
    }
    
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
//         return UIImageView(image: UIImage(named: "cards_\(index + 1)"))
        if(index == 0) {
            let imgView = UIImageView(image: UIImage(named: "BackgroundCard"))
            // Add the image
            let imageViewBackground = UIImageView(frame: paddedFrameImage)
            imageViewBackground.image = UIImage(named: "IconPhoneRecurLight")
            imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
            imageViewBackground.frame.origin.y = height*0.18 // 22 down from the top
            imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFit
            imgView.addSubview(imageViewBackground)
            // Create string
            let attributedHeaderString = NSMutableAttributedString(string: "Recurring Billing")
            let header = UILabel(frame: paddedFrame)
            header.frame.origin.y = height*0.35 // 20 down from the top
            header.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
            header.numberOfLines = 4
            header.attributedText = attributedHeaderString
            header.textAlignment = NSTextAlignment.Center
            header.textColor = UIColor.whiteColor()
            header.font = UIFont (name: "Nunito", size: 24)
            header.font = UIFont.boldSystemFontOfSize(24.0)
            imgView.addSubview(header)
            imgView.bringSubviewToFront(header)
            let attributedString = NSMutableAttributedString(string: "Leggings bushwick locavore, photo booth gastropub cornhole brooklyn man bun art party shoreditch. Salvia hoodie humblebrag, gastropub fingerstache lo-fi chia selvage meggings fanny pack. Franzen authentic normcore 8-bit tumblr. Ugh YOLO selvage tumblr butcher. IPhone gastropub irony food truck, authentic artisan gluten-free pop-up umami bicycle rights. Selfies chartreuse lumberjack, tacos venmo chicharrones you probably haven't heard of them YOLO everyday carry. PBR&B waistcoat cred, mlkshk 3 wolf moon knausgaard intelligentsia hoodie authentic dreamcatcher cronut lo-fi brooklyn YOLO paleo.")
            let text = UILabel(frame: paddedFrame)
            // Style for the text block
            text.frame.origin.y = height*0.45 // 20 down from the top
            text.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
            text.numberOfLines = 4
            text.attributedText = attributedString
            text.textAlignment = NSTextAlignment.Center
            text.textColor = UIColor.whiteColor()
            text.font = UIFont (name: "Nunito", size: 14)
            imgView.addSubview(text)
            return imgView
        } else if(index == 1) {
            let imgView = UIImageView(image: UIImage(named: "BackgroundCard"))
            // Add the image
            let imageViewBackground = UIImageView(frame: paddedFrameImage)
            imageViewBackground.image = UIImage(named: "IconNotifyLight")
            imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
            imageViewBackground.frame.origin.y = height*0.18 // 22 down from the top
            imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFit
            imgView.addSubview(imageViewBackground)
            // Create string
            let attributedHeaderString = NSMutableAttributedString(string: "Smart Notifications")
            let header = UILabel(frame: paddedFrame)
            header.frame.origin.y = height*0.35 // 20 down from the top
            header.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
            header.numberOfLines = 4
            header.attributedText = attributedHeaderString
            header.textAlignment = NSTextAlignment.Center
            header.textColor = UIColor.whiteColor()
            header.font = UIFont (name: "Nunito", size: 24)
            header.font = UIFont.boldSystemFontOfSize(24.0)
            imgView.addSubview(header)
            imgView.bringSubviewToFront(header)
            let attributedString = NSMutableAttributedString(string: "Leggings bushwick locavore, photo booth gastropub cornhole brooklyn man bun art party shoreditch. Salvia hoodie humblebrag, gastropub fingerstache lo-fi chia selvage meggings fanny pack. Franzen authentic normcore 8-bit tumblr. Ugh YOLO selvage tumblr butcher. IPhone gastropub irony food truck, authentic artisan gluten-free pop-up umami bicycle rights. Selfies chartreuse lumberjack, tacos venmo chicharrones you probably haven't heard of them YOLO everyday carry. PBR&B waistcoat cred, mlkshk 3 wolf moon knausgaard intelligentsia hoodie authentic dreamcatcher cronut lo-fi brooklyn YOLO paleo.")
            let text = UILabel(frame: paddedFrame)
            // Style for the text block
            text.frame.origin.y = height*0.45 // 20 down from the top
            text.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
            text.numberOfLines = 4
            text.attributedText = attributedString
            text.textAlignment = NSTextAlignment.Center
            text.textColor = UIColor.whiteColor()
            text.font = UIFont (name: "Nunito", size: 14)
            imgView.addSubview(text)
            return imgView
        } else if(index == 2) {
            let imgView = UIImageView(image: UIImage(named: "BackgroundCard"))
            // Add the image
            let imageViewBackground = UIImageView(frame: paddedFrameImage)
            imageViewBackground.image = UIImage(named: "IconCreditCardLight")
            imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
            imageViewBackground.frame.origin.y = height*0.18 // 22 down from the top
            imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFit
            imgView.addSubview(imageViewBackground)
            // Create string
            let attributedHeaderString = NSMutableAttributedString(string: "PCI DSS Compliant")
            let header = UILabel(frame: paddedFrame)
            header.frame.origin.y = height*0.35 // 20 down from the top
            header.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
            header.numberOfLines = 4
            header.attributedText = attributedHeaderString
            header.textAlignment = NSTextAlignment.Center
            header.textColor = UIColor.whiteColor()
            header.font = UIFont (name: "Nunito", size: 24)
            header.font = UIFont.boldSystemFontOfSize(24.0)
            imgView.addSubview(header)
            imgView.bringSubviewToFront(header)
            let attributedString = NSMutableAttributedString(string: "Leggings bushwick locavore, photo booth gastropub cornhole brooklyn man bun art party shoreditch. Salvia hoodie humblebrag, gastropub fingerstache lo-fi chia selvage meggings fanny pack. Franzen authentic normcore 8-bit tumblr. Ugh YOLO selvage tumblr butcher. IPhone gastropub irony food truck, authentic artisan gluten-free pop-up umami bicycle rights. Selfies chartreuse lumberjack, tacos venmo chicharrones you probably haven't heard of them YOLO everyday carry. PBR&B waistcoat cred, mlkshk 3 wolf moon knausgaard intelligentsia hoodie authentic dreamcatcher cronut lo-fi brooklyn YOLO paleo.")
            let text = UILabel(frame: paddedFrame)
            // Style for the text block
            text.frame.origin.y = height*0.45 // 20 down from the top
            text.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
            text.numberOfLines = 4
            text.attributedText = attributedString
            text.textAlignment = NSTextAlignment.Center
            text.textColor = UIColor.whiteColor()
            text.font = UIFont (name: "Nunito", size: 14)
            imgView.addSubview(text)
            return imgView
        } else if(index == 3) {
            let imgView = UIImageView(image: UIImage(named: "BackgroundCard"))
            // Add the image
            let imageViewBackground = UIImageView(frame: paddedFrameImage)
            imageViewBackground.image = UIImage(named: "IconTouchSecureLight")
            imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
            imageViewBackground.frame.origin.y = height*0.18 // 22 down from the top
            imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFit
            imgView.addSubview(imageViewBackground)
            // Create string
            let attributedHeaderString = NSMutableAttributedString(string: "Intelligent Security")
            let header = UILabel(frame: paddedFrame)
            header.frame.origin.y = height*0.35 // 20 down from the top
            header.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
            header.numberOfLines = 4
            header.attributedText = attributedHeaderString
            header.textAlignment = NSTextAlignment.Center
            header.textColor = UIColor.whiteColor()
            header.font = UIFont (name: "Nunito", size: 24)
            header.font = UIFont.boldSystemFontOfSize(24.0)
            imgView.addSubview(header)
            imgView.bringSubviewToFront(header)
            let attributedString = NSMutableAttributedString(string: "Leggings bushwick locavore, photo booth gastropub cornhole brooklyn man bun art party shoreditch. Salvia hoodie humblebrag, gastropub fingerstache lo-fi chia selvage meggings fanny pack. Franzen authentic normcore 8-bit tumblr. Ugh YOLO selvage tumblr butcher. IPhone gastropub irony food truck, authentic artisan gluten-free pop-up umami bicycle rights. Selfies chartreuse lumberjack, tacos venmo chicharrones you probably haven't heard of them YOLO everyday carry. PBR&B waistcoat cred, mlkshk 3 wolf moon knausgaard intelligentsia hoodie authentic dreamcatcher cronut lo-fi brooklyn YOLO paleo.")
            let text = UILabel(frame: paddedFrame)
            // Style for the text block
            text.frame.origin.y = height*0.45 // 20 down from the top
            text.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
            text.numberOfLines = 4
            text.attributedText = attributedString
            text.textAlignment = NSTextAlignment.Center
            text.textColor = UIColor.whiteColor()
            text.font = UIFont (name: "Nunito", size: 14)
            imgView.addSubview(text)
            return imgView
        } else if(index == 4) {
            let imgView = UIImageView(image: UIImage(named: "BackgroundCard"))
            // Add the image
            let imageViewBackground = UIImageView(frame: paddedFrameImage)
            imageViewBackground.image = UIImage(named: "IconSafeLight")
            imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
            imageViewBackground.frame.origin.y = height*0.18 // 22 down from the top
            imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFit
            imgView.addSubview(imageViewBackground)
            // Create string
            let attributedHeaderString = NSMutableAttributedString(string: "ACH Payments")
            let header = UILabel(frame: paddedFrame)
            header.frame.origin.y = height*0.35 // 20 down from the top
            header.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
            header.numberOfLines = 4
            header.attributedText = attributedHeaderString
            header.textAlignment = NSTextAlignment.Center
            header.textColor = UIColor.whiteColor()
            header.font = UIFont (name: "Nunito", size: 24)
            header.font = UIFont.boldSystemFontOfSize(24.0)
            imgView.addSubview(header)
            imgView.bringSubviewToFront(header)
            let attributedString = NSMutableAttributedString(string: "Leggings bushwick locavore, photo booth gastropub cornhole brooklyn man bun art party shoreditch. Salvia hoodie humblebrag, gastropub fingerstache lo-fi chia selvage meggings fanny pack. Franzen authentic normcore 8-bit tumblr. Ugh YOLO selvage tumblr butcher. IPhone gastropub irony food truck, authentic artisan gluten-free pop-up umami bicycle rights. Selfies chartreuse lumberjack, tacos venmo chicharrones you probably haven't heard of them YOLO everyday carry. PBR&B waistcoat cred, mlkshk 3 wolf moon knausgaard intelligentsia hoodie authentic dreamcatcher cronut lo-fi brooklyn YOLO paleo.")
            let text = UILabel(frame: paddedFrame)
            // Style for the text block
            text.frame.origin.y = height*0.45 // 20 down from the top
            text.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
            text.numberOfLines = 4
            text.attributedText = attributedString
            text.textAlignment = NSTextAlignment.Center
            text.textColor = UIColor.whiteColor()
            text.font = UIFont (name: "Nunito", size: 14)
            imgView.addSubview(text)
            return imgView
        }
        return UIImageView(image: UIImage(named: "cards_\(index + 1)"))
    }
    
    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
        return NSBundle.mainBundle().loadNibNamed("KolodaCustomOverlayView",
            owner: self, options: nil)[0] as? OverlayView
    }
}