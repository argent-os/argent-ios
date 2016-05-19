//
//  Extensions.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/12/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation

extension UISegmentedControl {
    func removeBorders() {
        setTitleTextAttributes(
            [NSForegroundColorAttributeName : UIColor.slateBlue(),
                NSFontAttributeName : UIFont(name: "Avenir-Book", size: 12)!],
            forState: .Normal)
        setTitleTextAttributes(
            [NSForegroundColorAttributeName : UIColor.darkBlue(),
                NSFontAttributeName : UIFont(name: "Avenir-Light", size: 18)!],
            forState: .Selected)
        setBackgroundImage(imageWithColor(UIColor.clearColor(), source: "IconEmpty"), forState: .Normal, barMetrics: .Default)
        setBackgroundImage(imageWithColor(UIColor.clearColor(), source: "IconEmpty"), forState: .Selected, barMetrics: .Default)
        setDividerImage(imageWithColor(UIColor.clearColor(), source: "IconEmpty"), forLeftSegmentState: .Normal, rightSegmentState: .Normal, barMetrics: .Default)
    }
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor, source: String) -> UIImage {
        let rect = CGRectMake(10.0, 0.0, 100.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
        let image = UIImage(named: source)
        UIGraphicsEndImageContext();
        return image!
    }
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
}
