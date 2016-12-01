//
//  New_BillsViewControllerViewController.swift
//  HW9_1
//
//  Created by 王优豪 on 11/22/16.
//  Copyright © 2016 Youhao-Wang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class New_BillsViewControllerViewController: UIViewController,UISearchBarDelegate {

    @IBOutlet weak var NewTable: UITableView!
    
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
        self.NewTable.addSubview(refreshControl)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.titleView = nil
        self.tabBarController?.navigationItem.title = "Bills"
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
            self.tabBarController?.navigationItem.title = "Bills"
            let searchBarButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Search")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.showSearchBar))
            self.tabBarController?.navigationItem.rightBarButtonItem = searchBarButton;
            self.filteredData = self.arrRes
            self.NewTable.reloadData()
        }, completion: { finished in
        })
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = arrRes.filter {
            return ($0["official_title"] as? String)?.range(of: searchText, options: .caseInsensitive) != nil  }
        self.NewTable.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    
    func UrlRequest() {
        let awsurl = "http://youhao.eypfwwr7rx.us-west-2.elasticbeanstalk.com"
        let parameters: Parameters = ["type": 4]
        Alamofire.request(awsurl, method: .get, parameters: parameters)
            .responseJSON { response in
                let swiftjsondata = JSON(response.result.value!)
                
                if let resData = swiftjsondata["results"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                    //self.arrRes.sort{ ($0["official_title"] as! String) < ($1["official_title"] as! String) }
                }
                self.filteredData = self.arrRes
                
                if self.arrRes.count > 0 {
                    self.NewTable.reloadData()
                }
        }
    }
}




extension New_BillsViewControllerViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "new_cell", for: indexPath)
        var dict = filteredData[indexPath.row]
        
        cell.textLabel?.text = ((dict["official_title"]) as? String)!
        
        if indexPath.row == 5 {
            SwiftSpinner.hide()
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100;//Choose your custom row height
    }
    
    
    
}


extension New_BillsViewControllerViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow;
        var dict = filteredData[(indexPath?.row)!]
        
        let storyboard = UIStoryboard(name: "BillDetail", bundle: nil)
        let BillDetail = storyboard.instantiateViewController(withIdentifier: "BillDetailViewController") as! BillDetailViewController
        BillDetail.passedValue = dict
        self.navigationController?.pushViewController(BillDetail, animated: true)
        
    }
}



