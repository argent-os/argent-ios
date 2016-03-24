//
//  RAMViewController.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 3/8/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//
//
//  ViewController.swift
//  RAMReel
//
//  Created by Mikhail Stepkin on 4/2/15.
//  Copyright (c) 2015 Ramotion. All rights reserved.
//

import Foundation
import UIKit
import RAMReel

@available(iOS 8.2, *)
class RAMViewController: UIViewController, UICollectionViewDelegate {
    
    var dataSource: SimplePrefixQueryDataSource!
    var ramReel: RAMReel<RAMCell, RAMTextField, SimplePrefixQueryDataSource>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = SimplePrefixQueryDataSource(data)
        ramReel = RAMReel(frame: self.view.bounds, dataSource: dataSource, placeholder: "Start by typing…") {
            print("Plain:", $0)
        }
        ramReel.hooks.append {
            let r = Array($0.characters.reverse())
            let j = String(r)
            print("Reversed:", j)
        }
        
        self.view.addSubview(ramReel.view)
        ramReel.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    }
    
    private let data: [String] = {
        do {
            if let dataPath = NSBundle.mainBundle().pathForResource("data", ofType: "txt") {
                let data = try WordReader(filepath: dataPath)
                return data.words
            } else {
                return []
            }
        }
        catch let error {
            print(error)
            return []
        }
    }()
    
}