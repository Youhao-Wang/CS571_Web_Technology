//
//  Favorite_CommitteeViewController.swift
//  HW9_1
//
//  Created by 王优豪 on 11/25/16.
//  Copyright © 2016 Youhao-Wang. All rights reserved.
//

import UIKit

class Favorite_CommitteeViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var committeeTable: UITableView!
    
     var favoriteCom = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationItem.title = "Favorite Committee"
        self.tabBarController?.navigationItem.rightBarButtonItem = editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        if let favoriteList = UserDefaults.standard.array(forKey: "favoriteCom") as? [[String: Any]] {
            favoriteCom = favoriteList
            
        }
        self.committeeTable.reloadData()
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteCom.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "committee_cell", for: indexPath)
        var dict = favoriteCom[indexPath.row]
        
        cell.textLabel?.text = ((dict["name"]) as? String)!
        cell.detailTextLabel?.text = dict["committee_id"] as? String
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow;
        let dict = favoriteCom[(indexPath?.row)!]
        
        let storyboard = UIStoryboard(name: "CommitteeDetail", bundle: nil)
        let CommitteeDetail = storyboard.instantiateViewController(withIdentifier: "CommitteeDetailViewController") as! CommitteeDetailViewController
        CommitteeDetail.passedValue = dict as [String : AnyObject]
        self.navigationController?.pushViewController(CommitteeDetail, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            favoriteCom.remove(at: indexPath.row)
            UserDefaults.standard.set(favoriteCom, forKey: "favoriteCom")
            UserDefaults.standard.synchronize()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.committeeTable.setEditing(editing, animated: animated)
    }


    
}
