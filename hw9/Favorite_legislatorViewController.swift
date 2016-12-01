//
//  Favorite_legislatorViewController.swift
//  HW9_1
//
//  Created by 王优豪 on 11/25/16.
//  Copyright © 2016 Youhao-Wang. All rights reserved.
//

import UIKit

class Favorite_legislatorViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var legislatorTable: UITableView!
    
    var favoriteLegislator = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.tabBarController?.navigationItem.title = "Favorite Legislators"
       self.tabBarController?.navigationItem.rightBarButtonItem = editButtonItem
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if let favoriteList = UserDefaults.standard.array(forKey: "favoriteLegislator") as? [[String: Any]] {
            favoriteLegislator = favoriteList
            self.favoriteLegislator.sort{ ($0["first_name"] as! String) < ($1["first_name"] as! String) }
        }
        self.legislatorTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteLegislator.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "legislatorCell", for: indexPath)
        var dict = favoriteLegislator[indexPath.row]
        var text = ""
        
        text = ((dict["first_name"]) as? String)!
        text += " " + ((dict["last_name"]) as? String)!
        cell.textLabel?.text = text
        
        cell.detailTextLabel?.text = dict["state_name"] as? String
        let bioId = dict["bioguide_id"] as? String
        
        let url = NSURL(string: "https://theunitedstates.io/images/congress/225x275/\(bioId!).jpg")
        if let data = NSData(contentsOf: url! as URL)
        {
            if let image = UIImage(data: data as Data){
                cell.imageView?.image = image
            }
        }
        
        
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow;
        var dict = favoriteLegislator[(indexPath?.row)!]
        
        let storyboard = UIStoryboard(name: "LegislatorDetail", bundle: nil)
        let LegislatorDetail = storyboard.instantiateViewController(withIdentifier: "LegislatorDetail_ViewController") as! LegislatorDetail_ViewController
        LegislatorDetail.passedValue = dict
        self.navigationController?.pushViewController(LegislatorDetail, animated: true)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            favoriteLegislator.remove(at: indexPath.row)
            UserDefaults.standard.set(favoriteLegislator, forKey: "favoriteLegislator")
            UserDefaults.standard.synchronize()

            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.legislatorTable.setEditing(editing, animated: animated)
    }

}
