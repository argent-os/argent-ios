//
//  BankConnectedDetailView.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 6/12/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import MCMHeaderAnimated

class BankConnectedDetailViewController: UIViewController {
    
    var element: NSDictionary! = nil
    
    @IBOutlet weak var header: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header.backgroundColor = self.element.objectForKey("color") as? UIColor
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}

extension BankConnectedDetailViewController: MCMHeaderAnimatedDelegate {
    
    func headerView() -> UIView {
        // Selected cell
        return self.header
    }
    
    func headerCopy(subview: UIView) -> UIView {
        let headerN = UIView()
        headerN.backgroundColor = self.element.objectForKey("color") as? UIColor
        return headerN
    }
    
}