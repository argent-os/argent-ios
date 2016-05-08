//
//  ActionSheet.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/8/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
//
//  Copyright (c) 2015 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import XLActionController

public class OptionsCell: ActionCell {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    func initialize() {
        backgroundColor = .whiteColor()
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(white: 0.0, alpha: 0.15)
        selectedBackgroundView = backgroundView
        separatorView?.backgroundColor = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1.0)
    }
}


public class ActionSection: Section<String, Void> {
    public override init() {
        super.init()
        self.data = ()
    }
}

public class ActionHeader: UICollectionReusableView {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGrayColor()
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping
        label.font = UIFont(name: "Avenir-Light", size: 14)
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        addSubview(label)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class ArgentActionController: ActionController<OptionsCell, String, ActionHeader, String, UICollectionReusableView, Void> {
    
    public override init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: NSBundle? = nil) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        settings.behavior.hideOnScrollDown = false
        settings.animation.scale = nil
        settings.animation.present.duration = 0.3
        settings.animation.dismiss.duration = 0.4
        settings.animation.dismiss.options = .CurveEaseInOut
        settings.animation.dismiss.offset = 30
        
        cellSpec = .NibFile(nibName: "OptionsCell", bundle: NSBundle(forClass: OptionsCell.self), height: { _ in 60})
        sectionHeaderSpec = .CellClass(height: { _ in 5 })
        headerSpec = .CellClass(height: { [weak self] (headerData: String) in
            guard let me = self else { return 0 }
            let label = UILabel(frame: CGRectMake(0, 0, me.view.frame.width - 40, CGFloat.max))
            label.numberOfLines = 0
            label.font = UIFont(name: "Avenir-Light", size: 14)
            label.text = headerData
            label.sizeToFit()
            return label.frame.size.height + 30
            })
        
        
        onConfigureHeader = { [weak self] header, headerData in
            guard let me = self else { return }
            header.label.frame = CGRectMake(0, 0, me.view.frame.size.width - 40, CGFloat.max)
            header.label.text = headerData
            header.label.sizeToFit()
            header.label.center = CGPointMake(header.frame.size.width  / 2, header.frame.size.height / 2)
        }
        onConfigureSectionHeader = { sectionHeader, sectionHeaderData in
            sectionHeader.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
        }
        onConfigureCellForAction = { [weak self] cell, action, indexPath in
            cell.setup(action.data, detail: nil, image: nil)
            cell.separatorView?.hidden = indexPath.item == self!.collectionView.numberOfItemsInSection(indexPath.section) - 1
            cell.alpha = action.enabled ? 1.0 : 0.5
            cell.actionTitleLabel?.textColor = action.style == .Destructive ? UIColor(red: 210/255.0, green: 77/255.0, blue: 56/255.0, alpha: 1.0) : UIColor.mediumBlue()
        }
    }
}
