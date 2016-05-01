//
//  TutorialHomeViewController.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 5/1/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit
import Gecco

class TutorialHomeViewController: SpotlightViewController {
    
    @IBOutlet var annotationViews: [UIView]!
    
    var stepIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }
    
    func next(labelAnimated: Bool) {
        updateAnnotationView(labelAnimated)
        
        let screenSize = UIScreen.mainScreen().bounds.size
        switch stepIndex {
        case 0:
            spotlightView.appear(Spotlight.Oval(center: CGPointMake(screenSize.width - 26, 42), diameter: 50))
        case 1:
            spotlightView.move(Spotlight.Oval(center: CGPointMake(screenSize.width - 75, 42), diameter: 50))
        case 2:
            spotlightView.move(Spotlight.RoundedRect(center: CGPointMake(screenSize.width / 2, 42), size: CGSizeMake(120, 40), cornerRadius: 6), moveType: .Disappear)
        case 3:
            spotlightView.move(Spotlight.Oval(center: CGPointMake(screenSize.width / 2, 200), diameter: 220), moveType: .Disappear)
        case 4:
            dismissViewControllerAnimated(true, completion: nil)
        default:
            break
        }
        
        stepIndex += 1
    }
    
    func updateAnnotationView(animated: Bool) {
        annotationViews.enumerate().forEach { index, view in
            UIView .animateWithDuration(animated ? 0.25 : 0) {
                view.alpha = index == self.stepIndex ? 1 : 0
            }
        }
    }
}

extension TutorialHomeViewController: SpotlightViewControllerDelegate {
    func spotlightViewControllerWillPresent(viewController: SpotlightViewController, animated: Bool) {
        next(false)
    }
    
    func spotlightViewControllerTapped(viewController: SpotlightViewController, isInsideSpotlight: Bool) {
        next(true)
    }
    
    func spotlightViewControllerWillDismiss(viewController: SpotlightViewController, animated: Bool) {
        spotlightView.disappear()
    }
}