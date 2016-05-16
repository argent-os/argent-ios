//
//  SearchViewController.swift
//  CustomSearchBar
//
//  Created by Gabriel Theodoropoulos on 8/9/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit
import JGProgressHUD
import Alamofire
import SwiftyJSON
import JGProgressHUD
import DGElasticPullToRefresh

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    var tblSearchResults:UITableView = UITableView()
    
    private var dataArray = [User]()
    
    private var filteredArray = [User]()
    
    private var shouldShowSearchResults = false
    
    private var searchController: UISearchController!
    
    private var searchedText:String = ""
    
    private var dateFormatter = NSDateFormatter()
    
    private var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    deinit {
        tblSearchResults.dg_removePullToRefresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // CRITICAL: Fixes view searchDetailController
        definesPresentationContext = true

        self.view.backgroundColor = UIColor.slateBlue()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        
        tblSearchResults.delegate = self
        tblSearchResults.dataSource = self
        tblSearchResults.frame = CGRect(x: 0, y: 15, width: screenWidth, height: screenHeight-62)
        self.view.addSubview(tblSearchResults)
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.whiteColor()
        tblSearchResults.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                self?.tblSearchResults.dg_stopLoading()
                self?.loadUserAccounts()
            })
            }, loadingView: loadingView)
        tblSearchResults.dg_setPullToRefreshFillColor(UIColor.mediumBlue())
        tblSearchResults.dg_setPullToRefreshBackgroundColor(UIColor.darkBlue())
        
        loadUserAccounts()
        
        configureSearchController()
    }
    
    override func viewDidAppear(animated: Bool) {
        // Set nav back button white
        UIStatusBarStyle.LightContent
        // self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    // MARK: UITableView Delegate and Datasource functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("customerDetailView", sender: self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredArray.count
        }
        else {
            return dataArray.count
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        self.tblSearchResults.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        let CellIdentifier: String = "Cell"
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: CellIdentifier)
        
        cell.imageView?.image = nil
        
        if shouldShowSearchResults {
            // After filtering
            let pic = filteredArray[indexPath.row].picture
            if pic != "" {
                let imageView: UIImageView = UIImageView(frame: CGRectMake(10, 15, 30, 30))
                imageView.backgroundColor = UIColor.clearColor()
                imageView.layer.cornerRadius = 15
                imageView.layer.masksToBounds = true
                let img: UIImage = UIImage(data: NSData(contentsOfURL: NSURL(string: pic)!)!)!
                imageView.image = img
                cell.contentView.addSubview(imageView)
            } else {
                let imageView: UIImageView = UIImageView(frame: CGRectMake(10, 15, 30, 30))
                imageView.backgroundColor = UIColor.clearColor()
                imageView.layer.cornerRadius = 15
                imageView.layer.masksToBounds = true
                imageView.image = UIImage(named: "PersonThumb")
                cell.contentView.addSubview(imageView)
            }
            cell.indentationWidth = 5; // The amount each indentation will move the text
            cell.indentationLevel = 8;  // The number of times you indent the text
            cell.textLabel?.text = "@" + String(filteredArray[indexPath.row].username)
            cell.textLabel?.textColor = UIColor.darkGrayColor()
            cell.textLabel?.font = UIFont.systemFontOfSize(14)
            cell.selectionStyle = UITableViewCellSelectionStyle.Default
            cell.detailTextLabel?.font = UIFont.systemFontOfSize(12)
            cell.detailTextLabel?.textColor = UIColor.lightGrayColor()
            
            let first_name = filteredArray[indexPath.row].first_name
            let last_name = String(filteredArray[indexPath.row].last_name)
            if first_name != "" || last_name != "" {
                cell.detailTextLabel?.text = first_name + " " + last_name
            } else {
                cell.detailTextLabel?.text = String(dataArray[indexPath.row].email)
            }
        }
        else {
            // Default loaded array
            let pic = dataArray[indexPath.row].picture
            if pic != "" {
                let imageView: UIImageView = UIImageView(frame: CGRectMake(10, 15, 30, 30))
                imageView.backgroundColor = UIColor.clearColor()
                imageView.layer.cornerRadius = 15
                imageView.layer.masksToBounds = true
                let img: UIImage = UIImage(data: NSData(contentsOfURL: NSURL(string: pic)!)!)!
                imageView.image = img
                cell.contentView.addSubview(imageView)
            } else {
                let imageView: UIImageView = UIImageView(frame: CGRectMake(10, 15, 30, 30))
                imageView.backgroundColor = UIColor.clearColor()
                imageView.layer.cornerRadius = 15
                imageView.layer.masksToBounds = true
                imageView.image = UIImage(named: "PersonThumb")
                cell.contentView.addSubview(imageView)
            }
            cell.indentationWidth = 5; // The amount each indentation will move the text
            cell.indentationLevel = 8;  // The number of times you indent the text
            cell.textLabel?.text = "@" + String(dataArray[indexPath.row].username)
            cell.textLabel?.textColor = UIColor.darkGrayColor()
            cell.textLabel?.font = UIFont(name: "Avenir", size: 14)
            cell.detailTextLabel?.font = UIFont(name: "Avenir", size: 10)
            cell.selectionStyle = UITableViewCellSelectionStyle.Default
            cell.detailTextLabel?.textColor = UIColor.darkGrayColor()
            
            let first_name = dataArray[indexPath.row].first_name
            let last_name = String(dataArray[indexPath.row].last_name)
            if first_name != "" || last_name != "" {
                cell.detailTextLabel?.text = first_name + " " + last_name
            } else {
                cell.detailTextLabel?.text = String(dataArray[indexPath.row].email)
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    
    // MARK: Custom functions
    
    func loadUserAccounts() {
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        User.getUserAccounts({ (items, error) in
            if error != nil
            {
                let alert = UIAlertController(title: "Error", message: "Could not load user accounts \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            self.dataArray = items!
            
            self.activityIndicator.stopAnimating()
                        
            self.tblSearchResults.reloadData()
        })
    }
    
    func configureSearchController() {
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = ""
        searchController.searchBar.sizeToFit()
        searchController.searchBar.frame = CGRect(x: 0, y: 210, width: screenWidth, height: 80)
        searchController.searchBar.translucent = false
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["Username", "Email", "Name"]
        
        // Place the search bar view to the tableview headerview.
        tblSearchResults.tableHeaderView = searchController.searchBar
    }
    
    
    // MARK: UISearchBarDelegate functions
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        shouldShowSearchResults = true
        searchController.searchBar.placeholder = "Search users"
        tblSearchResults.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        shouldShowSearchResults = false
        searchController.searchBar.placeholder = ""
        tblSearchResults.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tblSearchResults.reloadData()
        }
        searchController.searchBar.resignFirstResponder()
    }
    
    
    // MARK: UISearchResultsUpdating delegate function
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            return
        }
        
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
        
        // Filter the data array and get only those countries that match the search text.
        filteredArray = dataArray.filter({ (user) -> Bool in
            if(scope == "Username") {
                let userStr: NSString = user.username
                searchedText = userStr as String
                return (userStr.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
            } else if(scope == "Email") {
                let userStr: NSString = user.email
                searchedText = userStr as String
                return (userStr.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
            } else if(scope == "Name") {
                let userStr: NSString = user.first_name + " " + user.last_name
                searchedText = userStr as String
                return (userStr.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
            }
            
            return (user.username.lowercaseString.containsString(searchString.lowercaseString)) || (user.email.lowercaseString.containsString(searchString.lowercaseString))
        })
        
        // Reload the tableview.
        tblSearchResults.reloadData()
    }
    
    // Refresh
    private func refresh(sender:AnyObject)
    {
        self.loadUserAccounts()
    }
    
    // Search here
    private func didChangeSearchText(searchText: String) {
        // Filter the data array and get only those countries that match the search text.
        filteredArray = dataArray.filter({ (user) -> Bool in
            let userStr: NSString = user.username
            return (userStr.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
        })
        
        // Reload the tableview.
        tblSearchResults.reloadData()
    }
    
    private func filterContentForSearchText(searchText: String, scope: String) {
        filteredArray = filteredArray.filter({( user : User) -> Bool in
            _ = (scope == "Username") || (scope == "Email") || (scope == "Name")
            if(scope == "Username") {
                let userStr: NSString = user.username
                searchedText = userStr as String
                return (userStr.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
            } else if(scope == "Email") {
                let userStr: NSString = user.email
                searchedText = userStr as String
                return (userStr.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
            } else if(scope == "Name") {
                let userStr: NSString = user.first_name + " " + user.last_name
                searchedText = userStr as String
                return (userStr.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
            }
            
            return (user.username.lowercaseString.containsString(searchText.lowercaseString)) || (user.email.lowercaseString.containsString(searchText.lowercaseString))
        })
        tblSearchResults.reloadData()
    }
    
    // MARK: - UISearchBar Delegate
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    
    // MARK: - Segues // see tableView Delegate methods for indexPathForSelectedRow selection
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "customerDetailView" {
            if let indexPath = tblSearchResults.indexPathForSelectedRow {
                let user: User
                if searchController.active && searchController.searchBar.text != "" {
                    user = filteredArray[indexPath.row]
                } else {
                    user = dataArray[indexPath.row]
                }
                let controller = segue.destinationViewController as! SearchDetailViewController
                controller.detailUser = user
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
}

extension UITableView {
    public override func dg_stopScrollingAnimation() {}
}
