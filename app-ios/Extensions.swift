//
//  Extensions.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/12/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import Alamofire
import CWStatusBarNotification
import DynamicColor

let globalNotification = CWStatusBarNotification()

let headerAttrs: [String: AnyObject] = [
    NSForegroundColorAttributeName : UIColor.lightBlue(),
    NSFontAttributeName : UIFont(name: "DINAlternate-Bold", size: 20)!
]

let bodyAttrs: [String: AnyObject] = [
    NSForegroundColorAttributeName : UIColor.lightBlue().colorWithAlphaComponent(0.5),
    NSFontAttributeName : UIFont(name: "DINAlternate-Bold", size: 14)!
]

let calloutAttrs: [String: AnyObject] = [
    NSForegroundColorAttributeName : UIColor.lightBlue().colorWithAlphaComponent(0.85),
    NSFontAttributeName : UIFont(name: "DINAlternate-Bold", size: 14)!,
    NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue
]

extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}

extension UIImage{
    
    func alpha(value:CGFloat)->UIImage
    {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        
        let ctx = UIGraphicsGetCurrentContext();
        let area = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height);
        
        CGContextScaleCTM(ctx, 1, -1);
        CGContextTranslateCTM(ctx, 0, -area.size.height);
        CGContextSetBlendMode(ctx, CGBlendMode.Multiply);
        CGContextSetAlpha(ctx, value);
        CGContextDrawImage(ctx, area, self.CGImage);
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage;
    }
}


// Fix Push notification bug: _handleNonLaunchSpecificActions
extension UIApplication {
    func _handleNonLaunchSpecificActions(arg1: AnyObject, forScene arg2: AnyObject, withTransitionContext arg3: AnyObject, completion completionHandler: () -> Void) {
        //catching handleNonLaunchSpecificActions:forScene exception on app close
    }
}

extension UIColor {
    static func globalBackground() -> UIColor {
        return UIColor(rgba: "#fff")
    }
    static func bankCiti() -> UIColor {
        return UIColor(rgba: "#000066")
    }
    static func bankCitiAlt() -> UIColor {
        return UIColor(rgba: "#2b2be3")
    }
    static func bankAmex() -> UIColor {
        return UIColor(rgba: "#11A0DD")
    }
    static func bankAmexAlt() -> UIColor {
        return UIColor(rgba: "#2bb1e3")
    }
    static func bankBofa() -> UIColor {
        return UIColor(rgba: "#D4001A")
    }
    static func bankBofaAlt() -> UIColor {
        return UIColor(rgba: "#e32b49")
    }
    static func bankCapone() -> UIColor {
        return UIColor(rgba: "#003C70")
    }
    static func bankChase() -> UIColor {
        return UIColor(rgba: "#0f5ba7")
    }
    static func bankFidelity() -> UIColor {
        return UIColor(rgba: "#6ec260")
    }
    static func bankNavy() -> UIColor {
        return UIColor(rgba: "#04427e")
    }
    static func bankPnc() -> UIColor {
        return UIColor(rgba: "#f48024")
    }
    static func bankSchwab() -> UIColor {
        return UIColor(rgba: "#009fdf")
    }
    static func bankSuntrust() -> UIColor {
        return UIColor(rgba: "#f36b2b")
    }
    static func bankTd() -> UIColor {
        return UIColor(rgba: "#2db357")
    }
    static func bankUs() -> UIColor {
        return UIColor(rgba: "#0c2074")
    }
    static func bankUsaa() -> UIColor {
        return UIColor(rgba: "#00365b")
    }
    static func bankWells() -> UIColor {
        return UIColor(rgba: "#bb0826")
    }
    static func bitcoinOrange() -> UIColor {
        return UIColor(rgba: "#FF9900")
    }
    static func alipayBlue() -> UIColor {
        return UIColor(rgba: "#1aa1e6")
    }
    static func mediumBlue() -> UIColor {
        if APP_THEME == "LIGHT" {
            return UIColor(rgba: "#2c3441")
        } else {
            return UIColor(rgba: "#2c3441")
        }
    }
    static func darkBlue() -> UIColor {
        if APP_THEME == "LIGHT" {
            return UIColor(rgba: "#141c29")
        } else {
            return UIColor(rgba: "#141c29")
        }
    }
    static func lightBlue() -> UIColor {
        if APP_THEME == "LIGHT" {
            return UIColor(rgba: "#7b8999")
        } else {
            return UIColor(rgba: "#7b8999")
        }
    }
    static func skyBlue() -> UIColor {
        if APP_THEME == "LIGHT" {
            return UIColor(rgba: "#00b5ff")
        } else {
            return UIColor(rgba: "#00b5ff")
        }
    }
    static func limeGreen() -> UIColor {
        if APP_THEME == "LIGHT" {
            return UIColor(rgba: "#d8ff52")
        } else {
            return UIColor(rgba: "#d8ff52")
        }
    }
    static func slateBlue() -> UIColor {
        if APP_THEME == "LIGHT" {
            return UIColor(rgba: "#2c3441")
        } else {
            return UIColor(rgba: "#2c3441")
        }
    }
    static func brandYellow() -> UIColor {
        if APP_THEME == "LIGHT" {
            return UIColor(rgba: "#e5df1f")
        } else {
            return UIColor(rgba: "#e5df1f")
        }
    }
    static func brandGreen() -> UIColor {
        if APP_THEME == "LIGHT" {
            return UIColor(rgba: "#1ecc70")
        } else {
            return UIColor(rgba: "#0f49de")
        }
    }
    static func brandRed() -> UIColor {
        if APP_THEME == "LIGHT" {
            return UIColor(rgba: "#e84c4c")
        } else {
            return UIColor(rgba: "#fd0981")
        }
    }
    static func offWhite() -> UIColor {
        if APP_THEME == "LIGHT" {
            return UIColor(rgba: "#f5f7fa")
        } else {
            return UIColor(rgba: "#f5f7fa")
        }
    }
    static func iosBlue() -> UIColor {
        if APP_THEME == "LIGHT" {
            return UIColor(rgba: "#007aff")
        } else {
            return UIColor(rgba: "#007aff")
        }
    }
    static func neonBlue() -> UIColor {
        if APP_THEME == "LIGHT" {
            return UIColor(rgba: "#1cd7ec")
        } else {
            return UIColor(rgba: "#1cd7ec").invertColor()
        }
    }
    static func neonGreen() -> UIColor {
        if APP_THEME == "LIGHT" {
            return UIColor(rgba: "#23e839")
        } else {
            return UIColor(rgba: "#23e839").invertColor()
        }
    }
    static func neonYellow() -> UIColor {
        if APP_THEME == "LIGHT" {
            return UIColor(rgba: "#edef1b")
        } else {
            return UIColor(rgba: "#edef1b").invertColor()
        }
    }
    static func neonOrange() -> UIColor {
        if APP_THEME == "LIGHT" {
            return UIColor(rgba: "#f28225")
        } else {
            return UIColor(rgba: "#f28225").invertColor()
        }
    }
    static func neonPink() -> UIColor {
        if APP_THEME == "LIGHT" {
            return UIColor(rgba: "#fd0981")
        } else {
            return UIColor(rgba: "#fd0981").invertColor()
        }
    }
}

extension Float {
    func round(decimalPlace:Int)->Float{
        let format = NSString(format: "%%.%if", decimalPlace)
        let string = NSString(format: format, self)
        return Float(atof(string.UTF8String))
    }
}


extension NSMutableData {
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}

public func convertStringToDictionary(text: String) -> [String:AnyObject]? {
    if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
        do {
            return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
        } catch let error as NSError {
            print(error)
        }
    }
    return nil
}

func addSubviewWithBounce(view: UIView, parentView: UIViewController, duration: NSTimeInterval) {
    view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001)
    parentView.view.addSubview(view)
    UIView.animateWithDuration(duration / 1.5, animations: {() -> Void in
        view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)
        }, completion: {(finished: Bool) -> Void in
            UIView.animateWithDuration(duration / 2, animations: {() -> Void in
                }, completion: {(finished: Bool) -> Void in
                    UIView.animateWithDuration(duration / 2, animations: {() -> Void in
                        view.transform = CGAffineTransformIdentity
                    })
            })
    })
}

func addSubviewWithFade(view: UIView, parentView: UIViewController, duration: NSTimeInterval) {
    view.alpha = 0.0
    parentView.view.addSubview(view)
    UIView.animateWithDuration(duration, animations: {
        view.alpha = 1.0
    })
}


func addSubviewWithShadow(color: UIColor, radius: CGFloat, offsetX: CGFloat, offsetY: CGFloat, opacity: Float, parentView: UIViewController, childView: UIView) {
    childView.alpha = 0.0
    parentView.view.addSubview(childView)
    UIView.animateWithDuration(1.0, animations: {
        let containerLayer: CALayer = CALayer()
        containerLayer.shadowColor = color.CGColor
        containerLayer.shadowRadius = radius
        containerLayer.shadowOffset = CGSizeMake(offsetX, offsetY)
        containerLayer.shadowOpacity = opacity
        childView.layer.masksToBounds = true
        containerLayer.addSublayer(childView.layer)
        parentView.view.layer.addSublayer(containerLayer)
        childView.alpha = 1.0
    })
}

func addSubviewText(view: UIView, parentView: UIViewController, text: UILabel, frame: CGRect, str: NSAttributedString) {
    view.alpha = 0.0
    parentView.view.addSubview(view)
    UIView.animateWithDuration(1.0, animations: {
        view.alpha = 1.0
        text.attributedText = str
        view.addSubview(text)
    })
}

func showGlobalNotification(message: String, duration: NSTimeInterval, inStyle: CWNotificationAnimationStyle, outStyle: CWNotificationAnimationStyle, notificationStyle: CWNotificationStyle, color: UIColor) {
    globalNotification.notificationLabelBackgroundColor = color
    globalNotification.notificationAnimationInStyle = inStyle
    globalNotification.notificationAnimationOutStyle = outStyle
    globalNotification.notificationStyle = notificationStyle
    globalNotification.displayNotificationWithMessage(message, forDuration: duration)
}

func formatCurrency(amount: String, fontName: String, superSize: CGFloat, fontSize: CGFloat, offsetSymbol: Int, offsetCents: Int) -> NSAttributedString {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .CurrencyStyle
    let r = amount.startIndex..<amount.endIndex
    let x = amount.substringWithRange(r)
    let amt = formatter.stringFromNumber(Float(x)!/100)
    let font:UIFont? = UIFont(name: fontName, size: fontSize)
    let fontSuper:UIFont? = UIFont(name: fontName, size: superSize)
    let attString:NSMutableAttributedString = NSMutableAttributedString(string: amt!, attributes: [
        NSFontAttributeName:font!
    ])
    if Float(x) < 0 {
        attString.setAttributes([NSFontAttributeName:fontSuper!,NSBaselineOffsetAttributeName:offsetSymbol], range: NSRange(location:1,length:1))
        attString.setAttributes([NSFontAttributeName:fontSuper!,NSBaselineOffsetAttributeName:offsetCents], range: NSRange(location:(amt?.characters.count)!-2,length:2))
    } else {
        attString.setAttributes([NSFontAttributeName:fontSuper!,NSBaselineOffsetAttributeName:offsetSymbol], range: NSRange(location:0,length:1))
        attString.setAttributes([NSFontAttributeName:fontSuper!,NSBaselineOffsetAttributeName:offsetCents], range: NSRange(location:(amt?.characters.count)!-2,length:2))
    }
    
    return attString
}

func decimalWithString(formatter: NSNumberFormatter, string: String) -> NSDecimalNumber {
    formatter.generatesDecimalNumbers = true
    return formatter.numberFromString(string) as? NSDecimalNumber ?? 0
}

func addActivityIndicatorButton(indicator: UIActivityIndicatorView, button: UIButton, color: UIActivityIndicatorViewStyle) {
    let indicator: UIActivityIndicatorView = indicator
    let halfButtonHeight: CGFloat = button.bounds.size.height / 2
    let buttonWidth: CGFloat = button.bounds.size.width
    indicator.activityIndicatorViewStyle = color
    indicator.center = CGPointMake(buttonWidth - halfButtonHeight, halfButtonHeight)
    button.addSubview(indicator)
    indicator.hidesWhenStopped = true
    indicator.startAnimating()
    let _ = Timeout(2) {
        indicator.hidden = true
        indicator.stopAnimating()
    }
}

func addActivityIndicatorView(indicator: UIActivityIndicatorView, view: UIView, color: UIActivityIndicatorViewStyle) {
    let indicator: UIActivityIndicatorView = indicator
    let halfViewHeight: CGFloat = view.bounds.size.height / 2
    let halfViewWidth: CGFloat = view.bounds.size.width / 2
    indicator.activityIndicatorViewStyle = color
    indicator.center = CGPointMake(halfViewWidth, halfViewHeight)
    view.addSubview(indicator)
    indicator.hidesWhenStopped = true
    indicator.startAnimating()
    let _ = Timeout(2) {
        indicator.hidden = true
        indicator.stopAnimating()
    }
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), color.CGColor)
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, forState: forState)
}}

// concatenate attributed strings
func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
    let result = NSMutableAttributedString()
    result.appendAttributedString(left)
    result.appendAttributedString(right)
    return result
}


class SKTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 20, bottom: 1, right: 20);
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
