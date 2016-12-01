//
//  Senate_legislatorViewController.swift
//  HW9_1
//
//  Created by 王优豪 on 11/21/16.
//  Copyright © 2016 Youhao-Wang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import AlamofireImage

class Senate_legislatorViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var senateTable: UITableView!
    var arrRes = [[String:AnyObject]]() //Array of dictionary
    var filteredData = [[String:AnyObject]]()
    var searchBar = UISearchBar()
    var refreshControl: UIRefreshControl!
    var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.show("Fetching data...")
        super.viewDidLoad()
        self.searchBar.delegate = self
        UrlRequest()
        
        self.dateFormatter.dateStyle = .short
        self.dateFormatter.timeStyle = .long
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        self.senateTable.addSubview(refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.titleView = nil
        self.tabBarController?.navigationItem.title = "Legislators"
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
            self.tabBarController?.navigationItem.title = "Legislators"
            let searchBarButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Search")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.showSearchBar))
            self.tabBarController?.navigationItem.rightBarButtonItem = searchBarButton;
            self.filteredData = self.arrRes
            self.senateTable.reloadData()
        }, completion: { finished in
        })
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = arrRes.filter {
            return ($0["first_name"] as? String)?.range(of: searchText, options: .caseInsensitive) != nil  }
        self.senateTable.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    
    
    
    func UrlRequest() {
        let awsurl = "http://youhao.eypfwwr7rx.us-west-2.elasticbeanstalk.com"
        let parameters: Parameters = ["type": 13]
        Alamofire.request(awsurl, method: .get, parameters: parameters)
            .responseJSON { response in
                let swiftjsondata = JSON(response.result.value!)
                
                if let resData = swiftjsondata["results"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                    //self.arrRes.sort{ ($0["first_name"] as! String) < ($1["first_name"] as! String) }
                    self.arrRes.sort{   let first1 = $0["first_name"] as? String
                        let first2 = $1["first_name"] as? String
                        let last1 = $0["last_name"] as? String
                        let last2 = $1["last_name"] as? String
                        
                        if first1 == first2 {
                            return last1! < last2! }
                        else {
                            return first1! < first2!
                        }
                    }
                    
                }
                self.filteredData = self.arrRes
                
                if self.arrRes.count > 0 {
                    self.senateTable.reloadData()
                }
                SwiftSpinner.hide()

        }
    }

}


extension Senate_legislatorViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "senate_cell", for: indexPath)
        var dict = filteredData[indexPath.row]
        //var dict = arrRes[(indexPath as NSIndexPath).row]
        var text = ""
        
        text = ((dict["first_name"]) as? String)!
        text += " " + ((dict["last_name"]) as? String)!
        cell.textLabel?.text = text
        
        cell.detailTextLabel?.text = dict["state_name"] as? String
        let bioId = dict["bioguide_id"] as? String
        
        let url = NSURL(string: "https://theunitedstates.io/images/congress/225x275/\(bioId!).jpg")
        if indexPath.row < 14 {
            if let data = NSData(contentsOf: url! as URL)
            {
                if let image = UIImage(data: data as Data){
                    cell.imageView?.image = image
                }
            }
        }
        else{
            cell.imageView?.af_setImage(withURL: url! as URL)
        }
        
        return cell
    }
    
}


extension Senate_legislatorViewController : UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow;
        var dict = filteredData[(indexPath?.row)!]
        
        let storyboard = UIStoryboard(name: "LegislatorDetail", bundle: nil)
        let LegislatorDetail = storyboard.instantiateViewController(withIdentifier: "LegislatorDetail_ViewController") as! LegislatorDetail_ViewController
        LegislatorDetail.passedValue = dict
        self.navigationController?.pushViewController(LegislatorDetail, animated: true)
        
    }
}


