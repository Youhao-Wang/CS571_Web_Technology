//
//  Favorite_BillViewController.swift
//  HW9_1
//
//  Created by 王优豪 on 11/25/16.
//  Copyright © 2016 Youhao-Wang. All rights reserved.
//

import UIKit

class Favorite_BillViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var billTable: UITableView!
    
     var favoriteBill = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationItem.title = "Favorite Bills"
        self.tabBarController?.navigationItem.rightBarButtonItem = editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        if let favoriteList = UserDefaults.standard.array(forKey: "favoriteBill") as? [[String: Any]] {
            favoriteBill = favoriteList
            
        }
        self.billTable.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteBill.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bill_cell", for: indexPath)
        var dict = favoriteBill[indexPath.row]
        
        cell.textLabel?.text = ((dict["official_title"]) as? String)!
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100;//Choose your custom row height
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow;
        var dict = favoriteBill[(indexPath?.row)!]
        
        let storyboard = UIStoryboard(name: "BillDetail", bundle: nil)
        let BillDetail = storyboard.instantiateViewController(withIdentifier: "BillDetailViewController") as! BillDetailViewController
        BillDetail.passedValue = dict as [String : AnyObject]
        self.navigationController?.pushViewController(BillDetail, animated: true)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            favoriteBill.remove(at: indexPath.row)
            UserDefaults.standard.set(favoriteBill, forKey: "favoriteBill")
            UserDefaults.standard.synchronize()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.billTable.setEditing(editing, animated: animated)
    }

}
