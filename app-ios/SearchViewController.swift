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

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, SearchControllerDelegate {
    
    @IBOutlet weak var tblSearchResults: UITableView!
    
    var dataArray = [User]()
    
    var filteredArray = [User]()
    
    var shouldShowSearchResults = false
    
    var searchController: UISearchController!
    
    var customSearchController: SearchController!
    
    var searchedText:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tblSearchResults.delegate = self
        tblSearchResults.dataSource = self
        
        loadUserAccounts()
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 65))
        navBar.barTintColor = UIColor.protonBlue()
        navBar.tintColor = UIColor.whiteColor()
        navBar.translucent = false
        navBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "Helvetica", size: 18)!
        ]
        self.view.addSubview(navBar);
        let navItem = UINavigationItem(title: "Search");
        navBar.setItems([navItem], animated: false);
        
        // Uncomment the following line to enable the default search controller.
        configureSearchController()
        
        // Comment out the next line to disable the customized search controller and search bar and use the default ones. Also, uncomment the above line.
        //        configureCustomSearchController()
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
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredArray.count
        }
        else {
            return dataArray.count
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCell", forIndexPath: indexPath)
        
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
                imageView.image = UIImage(named: "ProtonLogo")
                cell.contentView.addSubview(imageView)
            }
            cell.indentationWidth = 5; // The amount each indentation will move the text
            cell.indentationLevel = 8;  // The number of times you indent the text
            cell.textLabel?.text = "@" + String(filteredArray[indexPath.row].username)
            cell.textLabel?.textColor = UIColor.darkGrayColor()
            cell.textLabel?.font = UIFont.systemFontOfSize(14)
            cell.detailTextLabel?.font = UIFont.systemFontOfSize(12)
            cell.detailTextLabel?.text = String(filteredArray[indexPath.row].first_name) + " " + String(filteredArray[indexPath.row].last_name)
            cell.selectionStyle = UITableViewCellSelectionStyle.Default
            cell.detailTextLabel?.textColor = UIColor.lightGrayColor()
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
                imageView.image = UIImage(named: "ProtonLogo")
                cell.contentView.addSubview(imageView)
            }
            cell.indentationWidth = 5; // The amount each indentation will move the text
            cell.indentationLevel = 8;  // The number of times you indent the text
            cell.textLabel?.text = "@" + String(dataArray[indexPath.row].username)
            cell.textLabel?.textColor = UIColor.darkGrayColor()
            cell.textLabel?.font = UIFont.systemFontOfSize(14)
            cell.detailTextLabel?.font = UIFont.systemFontOfSize(12)
            cell.detailTextLabel?.text = String(dataArray[indexPath.row].first_name) + " " + String(dataArray[indexPath.row].last_name)
            cell.selectionStyle = UITableViewCellSelectionStyle.Default
            cell.detailTextLabel?.textColor = UIColor.lightGrayColor()
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    
    // MARK: Custom functions
    
    func loadUserAccounts() {
        let HUD: JGProgressHUD = JGProgressHUD.init(style: JGProgressHUDStyle.ExtraLight)
        HUD.showInView(self.view!)
        User.getUserAccounts({ (items, error) in
            if error != nil
            {
                let alert = UIAlertController(title: "Error", message: "Could not load user accounts \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            self.dataArray = items!
            
            HUD.dismiss()

            self.tblSearchResults.reloadData()
        })
    }
    
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter search"
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["Username", "Email", "Name"]
        
        // Place the search bar view to the tableview headerview.
        tblSearchResults.tableHeaderView = searchController.searchBar
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        
        let sendToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, screenWidth, 50))
        // sendToolbar.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Add Filters", style: UIBarButtonItemStyle.Done, target: self, action: nil)
        done.tintColor = UIColor.whiteColor()
        UIToolbar.appearance().barTintColor = UIColor.protonBlue()
        done.setTitleTextAttributes([
            NSFontAttributeName : UIFont(name: "Nunito-SemiBold", size: 15.0)!,
            NSForegroundColorAttributeName : UIColor(rgba: "#fff")
            ], forState: .Normal)
        
        var items: [UIBarButtonItem]? = [UIBarButtonItem]()
        items?.append(flexSpace)
        items?.append(done)
        items?.append(flexSpace)
        
        sendToolbar.items = items
        sendToolbar.sizeToFit()
        // Uncomment to add toolbar to search
        // searchController.searchBar.inputAccessoryView=sendToolbar
    }
    
    func configureCustomSearchController() {
        customSearchController = SearchController(searchResultsController: self, searchBarFrame: CGRectMake(0.0, 0.0, tblSearchResults.frame.size.width, 50.0), searchBarFont: UIFont(name: "Nunito-SemiBold", size: 16.0)!, searchBarTextColor: UIColor.whiteColor(), searchBarTintColor: UIColor.blackColor())
        
        customSearchController.customSearchBar.placeholder = "Search"
        tblSearchResults.tableHeaderView = customSearchController.customSearchBar
        
        customSearchController.customDelegate = self
    }
    
    
    // MARK: UISearchBarDelegate functions
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tblSearchResults.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        shouldShowSearchResults = false
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
                print("username filtered")
                let userStr: NSString = user.username
                searchedText = userStr as String
                print(userStr)
                print((userStr.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch).location))
                return (userStr.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
            } else if(scope == "Email") {
                print("email filtered")
                let userStr: NSString = user.email
                searchedText = userStr as String
                print(userStr)
                print((userStr.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch).location))
                return (userStr.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
            } else if(scope == "Name") {
                print("name filtered")
                let userStr: NSString = user.first_name + " " + user.last_name
                searchedText = userStr as String
                print(userStr)
                print((userStr.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch).location))
                return (userStr.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
            }
            
            return (user.username.lowercaseString.containsString(searchString.lowercaseString)) || (user.email.lowercaseString.containsString(searchString.lowercaseString))
        })
        
        // Reload the tableview.
        tblSearchResults.reloadData()
    }
    
    
    // MARK: CustomSearchControllerDelegate functions
    
    func didStartSearching() {
        shouldShowSearchResults = true
        tblSearchResults.reloadData()
    }
    
    
    func didTapOnSearchButton() {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tblSearchResults.reloadData()
        }
    }
    
    
    func didTapOnCancelButton() {
        shouldShowSearchResults = false
        tblSearchResults.reloadData()
    }
    
    // Search here
    func didChangeSearchText(searchText: String) {
        // Filter the data array and get only those countries that match the search text.
        filteredArray = dataArray.filter({ (user) -> Bool in
            let userStr: NSString = user.username
            return (userStr.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
        })
        
        // Reload the tableview.
        tblSearchResults.reloadData()
    }
    
    func filterContentForSearchText(searchText: String, scope: String) {
        filteredArray = filteredArray.filter({( user : User) -> Bool in
            let categoryMatch = (scope == "Username") || (scope == "Email") || (scope == "Name")
            print("filtering used")
            if(scope == "Username") {
                print("username filtered")
                let userStr: NSString = user.username
                searchedText = userStr as String
                print(userStr)
                print((userStr.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch).location))
                return (userStr.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
            } else if(scope == "Email") {
                print("email filtered")
                let userStr: NSString = user.email
                searchedText = userStr as String
                print(userStr)
                print((userStr.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch).location))
                return (userStr.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
            } else if(scope == "Name") {
                print("name filtered")
                let userStr: NSString = user.first_name + " " + user.last_name
                searchedText = userStr as String
                print(userStr)
                print((userStr.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch).location))
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
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("preparing for segue")
        if segue.identifier == "customerDetailView" {
            print("segue identified")
            print(segue.identifier)
            if let indexPath = tblSearchResults.indexPathForSelectedRow {
                print("inside indexpathforselectedrow")
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

