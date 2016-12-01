//
//  Joint_committeeViewController.swift
//  HW9_1
//
//  Created by 王优豪 on 11/23/16.
//  Copyright © 2016 Youhao-Wang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner


class Joint_committeeViewController: UIViewController,UISearchBarDelegate {

    @IBOutlet weak var joint_table: UITableView!
    
    var refreshControl: UIRefreshControl!
    var dateFormatter = DateFormatter()
    
    var arrRes = [[String:AnyObject]]() //Array of dictionary
    var filteredData = [[String:AnyObject]]()
    var searchBar = UISearchBar()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.show(duration: 4.0, title: "Fetching data...")
        super.viewDidLoad()
        self.searchBar.delegate = self
        UrlRequest()
        
        self.dateFormatter.dateStyle = .short
        self.dateFormatter.timeStyle = .long
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        self.joint_table.addSubview(refreshControl)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.titleView = nil
        self.tabBarController?.navigationItem.title = "Committee"
        let searchBarButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Search")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.showSearchBar))
        self.tabBarController?.navigationItem.rightBarButtonItem = searchBarButton;
    }
    
    
    func refresh(sender:AnyObject) {
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        SwiftSpinner.show(duration: 2.0, title: "Fetching data...")
        self.filteredData = self.arrRes
        UrlRequest()
        let now = NSDate()
        let updateString = "Last Updated at " + self.dateFormatter.string(from: now as Date)
        self.refreshControl.attributedTitle = NSAttributedString(string: updateString)
        self.refreshControl.endRefreshing()
    }
    
    
    func showSearchBar() {
        searchBar.placeholder = "Search here..."
        searchBar.alpha = 0
        self.tabBarController?.navigationItem.titleView = searchBar
        
        let CancelBarButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Cancel")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.hideSearchBar))
        self.tabBarController?.navigationItem.rightBarButtonItem = CancelBarButton;
        
        UIView.animate(withDuration: 0.5, animations: {
            self.searchBar.alpha = 1
        }, completion: { finished in
            self.searchBar.becomeFirstResponder()
        })
    }
    
    
    func hideSearchBar() {
        searchBar.text = ""
        UIView.animate(withDuration: 0.3, animations: {
            self.tabBarController?.navigationItem.titleView = nil
            self.tabBarController?.navigationItem.title = "Committee"
            let searchBarButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Search")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.showSearchBar))
            self.tabBarController?.navigationItem.rightBarButtonItem = searchBarButton;
            self.filteredData = self.arrRes
            self.joint_table.reloadData()
        }, completion: { finished in
        })
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = arrRes.filter {
            return ($0["name"] as? String)?.range(of: searchText, options: .caseInsensitive) != nil  }
        self.joint_table.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    
    
    func UrlRequest() {
        let awsurl = "http://youhao.eypfwwr7rx.us-west-2.elasticbeanstalk.com"
        let parameters: Parameters = ["type": 32]
        Alamofire.request(awsurl, method: .get, parameters: parameters)
            .responseJSON { response in
                let swiftjsondata = JSON(response.result.value!)
                
                if let resData = swiftjsondata["results"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                    self.arrRes.sort{ ($0["name"] as! String) < ($1["name"] as! String) }
                }
                self.filteredData = self.arrRes
                
                if self.arrRes.count > 0 {
                    self.joint_table.reloadData()
                }
        }
    }
}



extension Joint_committeeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "jointCell", for: indexPath)
        var dict = filteredData[indexPath.row]
        
        cell.textLabel?.text = ((dict["name"]) as? String)!
        cell.detailTextLabel?.text = dict["committee_id"] as? String
        
        if indexPath.row == 4 {
            SwiftSpinner.hide()
        }
        return cell
    }
    
    
}


extension Joint_committeeViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow;
        var dict = filteredData[(indexPath?.row)!]
        
        let storyboard = UIStoryboard(name: "CommitteeDetail", bundle: nil)
        let CommitteeDetail = storyboard.instantiateViewController(withIdentifier: "CommitteeDetailViewController") as! CommitteeDetailViewController
        CommitteeDetail.passedValue = dict
        self.navigationController?.pushViewController(CommitteeDetail, animated: true)
        
    }
}



