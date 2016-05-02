//
//  RAMTabBarExtension.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 4/24/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import RAMAnimatedTabBarController

extension RAMAnimatedTabBarController {
    
    // MARK: life circle
    
    private func createCustomIcons(containers : NSDictionary) {
        guard let items = tabBar.items as? [RAMAnimatedTabBarItem] else {
            fatalError("items must inherit RAMAnimatedTabBarItem")
        }
        
        var index = 0
        for item in items {
            
            guard let itemImage = item.image else {
                fatalError("add image icon in UITabBarItem")
            }
            
            guard let container = containers["container\(items.count - 1 - index)"] as? UIView else {
                fatalError()
            }
            container.tag = index
            
            
            let renderMode = CGColorGetAlpha(item.iconColor.CGColor) == 0 ? UIImageRenderingMode.AlwaysOriginal :
                UIImageRenderingMode.AlwaysTemplate
            
            let icon = UIImageView(image: item.image?.imageWithRenderingMode(renderMode))
            icon.translatesAutoresizingMaskIntoConstraints = false
            icon.tintColor = item.iconColor
            
            // text
            let textLabel = UILabel()
            textLabel.text = item.title
            textLabel.backgroundColor = UIColor.clearColor()
            textLabel.textColor = item.textColor
            textLabel.font = item.textFont
            textLabel.textAlignment = NSTextAlignment.Center
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            
            
            container.addSubview(icon)
            if let itemImage = item.image {
                if 2 == index { // selected first elemet
                    createConstraints(icon, container: container, size: itemImage.size, yOffset: 0)
                } else {
                    createConstraints(icon, container: container, size: itemImage.size, yOffset: -5)
                    
                }
            }
            container.addSubview(textLabel)
            let textLabelWidth = tabBar.frame.size.width / CGFloat(items.count) - 5.0
            createConstraints(textLabel, container: container, size: CGSize(width: textLabelWidth , height: 10), yOffset: 16)
            
            item.iconView = (icon:icon, textLabel:textLabel)
            
            item.image = nil
            item.title = ""
            index += 1
        }
    }
    
    private func createConstraints(view:UIView, container:UIView, size:CGSize, yOffset:CGFloat) {
        
        let constX = NSLayoutConstraint(item: view,
                                        attribute: NSLayoutAttribute.CenterX,
                                        relatedBy: NSLayoutRelation.Equal,
                                        toItem: container,
                                        attribute: NSLayoutAttribute.CenterX,
                                        multiplier: 1,
                                        constant: 0)
        container.addConstraint(constX)
        
        let constY = NSLayoutConstraint(item: view,
                                        attribute: NSLayoutAttribute.CenterY,
                                        relatedBy: NSLayoutRelation.Equal,
                                        toItem: container,
                                        attribute: NSLayoutAttribute.CenterY,
                                        multiplier: 1,
                                        constant: yOffset)
        container.addConstraint(constY)
        
        let constW = NSLayoutConstraint(item: view,
                                        attribute: NSLayoutAttribute.Width,
                                        relatedBy: NSLayoutRelation.Equal,
                                        toItem: nil,
                                        attribute: NSLayoutAttribute.NotAnAttribute,
                                        multiplier: 1,
                                        constant: size.width)
        view.addConstraint(constW)
        
        let constH = NSLayoutConstraint(item: view,
                                        attribute: NSLayoutAttribute.Height,
                                        relatedBy: NSLayoutRelation.Equal,
                                        toItem: nil,
                                        attribute: NSLayoutAttribute.NotAnAttribute,
                                        multiplier: 1,
                                        constant: size.height)
        view.addConstraint(constH)
    }



}
