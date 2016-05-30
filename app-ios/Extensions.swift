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

func transparentNav() {
    UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
    // Sets shadow (line below the bar) to a blank image
    UINavigationBar.appearance().shadowImage = UIImage()
    // Sets the translucent background color
    UINavigationBar.appearance().backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    // Set translucent. (Default value is already true, so this can be removed if desired.)
    UINavigationBar.appearance().translucent = true
}

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
    static func mediumBlue() -> UIColor {
        return UIColor(rgba: "#2c3441")
    }
    static func darkBlue() -> UIColor {
        return UIColor(rgba: "#141c29")
    }
    static func lightBlue() -> UIColor {
        return UIColor(rgba: "#7b8999")
    }
    static func limeGreen() -> UIColor {
        return UIColor(rgba: "#d8ff52")
    }
    static func slateBlue() -> UIColor {
        return UIColor(rgba: "#2c3441")
    }
    static func brandYellow() -> UIColor {
        return UIColor(rgba: "#FFCF4B")
    }
    static func brandGreen() -> UIColor {
        return UIColor(rgba: "#2ECC71")
    }
    static func brandRed() -> UIColor {
        return UIColor(rgba: "#f74e1d")
    }
    static func offWhite() -> UIColor {
        return UIColor(rgba: "#f5f7fa")
    }
    static func iosBlue() -> UIColor {
        return UIColor(rgba: "#007aff")
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

func addSubviewWithBounce(view: UIView, parentView: UIViewController) {
    view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001)
    parentView.view.addSubview(view)
    UIView.animateWithDuration(0.3 / 1.5, animations: {() -> Void in
        view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)
        }, completion: {(finished: Bool) -> Void in
            UIView.animateWithDuration(0.3 / 2, animations: {() -> Void in
                }, completion: {(finished: Bool) -> Void in
                    UIView.animateWithDuration(0.3 / 2, animations: {() -> Void in
                        view.transform = CGAffineTransformIdentity
                    })
            })
    })
}

func addSubviewWithFade(view: UIView, parentView: UIViewController) {
    view.alpha = 0.0
    parentView.view.addSubview(view)
    UIView.animateWithDuration(1.0, animations: {
        view.alpha = 1.0
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
    let r = Range<String.Index>(start: amount.startIndex, end: amount.endIndex)
    let x = amount.substringWithRange(r)
    let amt = formatter.stringFromNumber(Float(x)!/100)
    let font:UIFont? = UIFont(name: fontName, size: fontSize)
    let fontSuper:UIFont? = UIFont(name: fontName, size: superSize)
    let attString:NSMutableAttributedString = NSMutableAttributedString(string: amt!, attributes: [NSFontAttributeName:font!])
    if Float(x) < 0 {
        attString.setAttributes([NSFontAttributeName:fontSuper!,NSBaselineOffsetAttributeName:offsetSymbol], range: NSRange(location:1,length:1))
        attString.setAttributes([NSFontAttributeName:fontSuper!,NSBaselineOffsetAttributeName:offsetCents], range: NSRange(location:(amt?.characters.count)!-2,length:2))
    } else {
        attString.setAttributes([NSFontAttributeName:fontSuper!,NSBaselineOffsetAttributeName:offsetSymbol], range: NSRange(location:0,length:1))
        attString.setAttributes([NSFontAttributeName:fontSuper!,NSBaselineOffsetAttributeName:offsetCents], range: NSRange(location:(amt?.characters.count)!-2,length:2))
    }
    return attString
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
func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString
{
    let result = NSMutableAttributedString()
    result.appendAttributedString(left)
    result.appendAttributedString(right)
    return result
}
