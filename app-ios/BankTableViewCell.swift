//
//  BankTableViewCell.swift
//  Example
//
//  Created by Mathias Carignani on 5/19/15.
//  Copyright (c) 2015 Mathias Carignani. All rights reserved.
//

import UIKit

class BankTableViewCell: UITableViewCell {
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var header: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Here you can customize the appearance of your cell
    override func layoutSubviews() {
        let width = UIScreen.mainScreen().bounds.size.width
        
        super.layoutSubviews()
        // Customize imageView like you need
        self.imageView?.frame = CGRectMake(width/2-50,40,100,100)
        self.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
    }
}

