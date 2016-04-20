//
//  SearchDetailViewController.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 4/20/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit

class SearchDetailViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var stacks: UIStackView!
    
    var detailUser: User? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        if let detailUser = detailUser {
              print("inside detail user")
            if let usernameLabel = usernameLabel, userImageView = userImageView {
                // Set to specific user fields later
                usernameLabel.text = detailUser.username
                emailLabel.text = detailUser.email
//                userImageView.image = UIImage(named: detailUser.username)
                userImageView.image = UIImage(named: "IconPerson")
                title = detailUser.username
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

