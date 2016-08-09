//
//  CustomersListDetailViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 6/6/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import DZNEmptyDataSet

class CustomersListDetailViewController: UIViewController, UINavigationBarDelegate, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    let navigationBar = UINavigationBar()
    
    var customerEmail:String?
    
    var customerId: String?
    
    var customerEmailTitleLabel = UILabel()

    var customerSubscriptions = [Subscription]()
    
    var viewRefreshControl = UIRefreshControl()
    
    var dateFormatter = NSDateFormatter()

    private var tableView:UITableView = UITableView()

    private let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutViews()
        setupNav()
        addInfiniteScroll()
    }
    
    private func addInfiniteScroll() {
        // Add infinite scroll handler
        // change indicator view style to white
        self.tableView.infiniteScrollIndicatorStyle = .Gray
        
        // Add infinite scroll handler
        self.tableView.addInfiniteScrollWithHandler { (scrollView) -> Void in
            let tableView = scrollView as! UITableView
            
            //
            // fetch your data here, can be async operation,
            // just make sure to call finishInfiniteScroll in the end
            //
            
            // make sure you reload tableView before calling -finishInfiniteScroll
            tableView.reloadData()
            
            // finish infinite scroll animation
            tableView.finishInfiniteScroll()
        }
    }
    
    func layoutViews() {
        
        self.navigationController?.navigationBar.tintColor = UIColor.lightBlue()
        self.navigationController?.navigationBar.topItem!.backBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.emptyDataSetSource = self
        self.tableView.showsVerticalScrollIndicator = false
        // trick to make table lines disappear
        self.tableView.tableFooterView = UIView()
        self.tableView.frame = CGRect(x: 0, y: 100, width: screenWidth, height: screenHeight-100)
        self.view.addSubview(tableView)
        
        customerEmailTitleLabel.frame = CGRect(x: 40, y: 20, width: screenWidth-80, height: 100)
        customerEmailTitleLabel.attributedText = adjustAttributedString(customerEmail!, spacing: 1, fontName: "MyriadPro-Regular", fontSize: 19, fontColor: UIColor.darkBlue(), lineSpacing: 0.0)
        customerEmailTitleLabel.textAlignment = .Center
        addSubviewWithBounce(customerEmailTitleLabel, parentView: self, duration: 0.3)
        
        self.getCustomerInformation()
        
        let splitterView = UIView()
        splitterView.backgroundColor = UIColor.lightBlue().colorWithAlphaComponent(0.3)
        splitterView.frame = CGRect(x: 40, y: 100, width: screenWidth-80, height: 1)
        self.view.addSubview(splitterView)
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.whiteColor()
        headerView.frame = CGRect(x: 0, y: 10, width: screenWidth, height: 60)
        self.tableView.tableHeaderView = headerView
        let headerViewTitle: UILabel = UILabel()
        headerViewTitle.frame = CGRect(x: 0, y: 20, width: screenWidth, height: 35)
        headerViewTitle.attributedText = adjustAttributedString("SUBSCRIPTIONS", spacing: 1, fontName: "MyriadPro-Regular", fontSize: 13, fontColor: UIColor.lightBlue(), lineSpacing: 0.0)
        headerViewTitle.textAlignment = .Center
        headerView.addSubview(headerViewTitle)
        
        self.viewRefreshControl.backgroundColor = UIColor.clearColor()
        self.viewRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.viewRefreshControl.addTarget(self, action: #selector(self.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(viewRefreshControl)
    }
    
    private func getCustomerInformation() {
        let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicator.center = self.tableView.center
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        // update "last updated" title for refresh control
        let now = NSDate()
        let updateString = "Last Updated at " + self.dateFormatter.stringFromDate(now)
        self.viewRefreshControl.attributedTitle = NSAttributedString(string: updateString)
        Customer.getSingleCustomer(customerId!) { (customer, subscriptions, err) in
//            print(customer)
//            print(subscriptions)
            self.customerSubscriptions = subscriptions
            self.tableView.reloadData()
            activityIndicator.stopAnimating()
            if self.viewRefreshControl.refreshing {
                self.viewRefreshControl.endRefreshing()
            }
        }
    }
    
    func refresh(sender:AnyObject) {
        self.getCustomerInformation()
    }
    
    private func setupNav() {
        // Offset by 20 pixels vertically to take the status bar into account
        navigationBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 60)
        navigationBar.backgroundColor = UIColor.clearColor()
        
        // sets color of close icon
        navigationBar.tintColor = UIColor.oceanBlue()
        navigationBar.delegate = self
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        
        // Create left and right button for navigation item
        let leftButton = UIBarButtonItem(image: UIImage(named: "IconCloseLight"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.returnToMenu(_:)))
        let font = UIFont(name: "MyriadPro-Regular", size: 14)
        leftButton.setTitleTextAttributes([NSFontAttributeName: font!, NSForegroundColorAttributeName:UIColor.mediumBlue()], forState: UIControlState.Normal)
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
        
        // Assign the navigation item to the navigation bar
        navigationBar.titleTextAttributes = [NSFontAttributeName: font!, NSForegroundColorAttributeName:UIColor.lightBlue()]
        navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
    }
    
    func returnToMenu(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
}

extension CustomersListDetailViewController {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.customerSubscriptions.count ?? 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        let CellIdentifier: String = "Cell"
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: CellIdentifier)
        let item = self.customerSubscriptions[indexPath.row]
        //print(item)
        cell.textLabel?.text = ""
        cell.detailTextLabel?.text = ""
        
        if let name = item.plan_name {
            let strName = name
            cell.textLabel?.attributedText = NSAttributedString(string: strName + " ", attributes: [
                NSForegroundColorAttributeName : UIColor.mediumBlue(),
                NSFontAttributeName : UIFont(name: "MyriadPro-Regular", size: 14)!
                ])
        }
        if let amount = item.plan_amount, interval = item.plan_interval, qty = item.quantity, status = item.status {
            cell.detailTextLabel?.textColor = UIColor.darkBlue()
            let amountStr = currencyStringFromNumber(Double(amount)/100)
            cell.detailTextLabel?.attributedText = adjustAttributedString(amountStr + " per " + interval, spacing: 1, fontName: "MyriadPro-Regular", fontSize: 13, fontColor: UIColor.darkBlue(), lineSpacing: 0.0)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90.0
    }
    
}


extension CustomersListDetailViewController {
    // Delegate: DZNEmptyDataSet
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = ""
        return NSAttributedString(string: str, attributes: headerAttrs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "This customer has no subscriptions."
        // let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: bodyAttrs)
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "IconEmpty")
    }
    
    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
        let str = ""
        // let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleCallout)]
        return NSAttributedString(string: str, attributes: calloutAttrs)
    }
    
    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {

    }
}
