//
//  BankConnectedTableViewCell.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 4/6/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit

class BankConnectedTableViewCell: UITableViewCell {
    
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
        let height = UIScreen.mainScreen().bounds.size.height
        
        super.layoutSubviews()
        // Customize imageView like you need
        self.imageView?.frame = CGRectMake(0,0,width,180)
        self.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
    }
}

