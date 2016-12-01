//
//  CommitteeDetailViewController.swift
//  HW9_1
//
//  Created by 王优豪 on 11/23/16.
//  Copyright © 2016 Youhao-Wang. All rights reserved.
//

import UIKit

class CommitteeDetailViewController: UIViewController,UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var text: UITextView!
    
    var passedValue = [String:AnyObject]()
    var datasource = [String]()
    
    var favoriteLegislator = [[String:AnyObject]]()
    var index = 0
    
    
    
    func addFavorite() {
        let yesFavorite: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "favorite_Fill")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.removeFavorite))
        navigationItem.rightBarButtonItem = yesFavorite;
        
        let keysToRemove = passedValue.nullKeyRemoval()
        favoriteLegislator.append(keysToRemove)
        UserDefaults.standard.set(favoriteLegislator, forKey: "favoriteCom")
        UserDefaults.standard.synchronize()
    }
    
    func removeFavorite() {
        let noFavorite: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "favorite")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.addFavorite))
        navigationItem.rightBarButtonItem = noFavorite;
        favoriteLegislator.remove(at: index)
        index = favoriteLegislator.count
        UserDefaults.standard.set(favoriteLegislator, forKey: "favoriteCom")
        UserDefaults.standard.synchronize()
    }

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Committee Details"
        
        let comid = passedValue["committee_id"] as! String
        if let favoriteList = UserDefaults.standard.array(forKey: "favoriteCom") as? [[String: Any]] {
            favoriteLegislator = favoriteList as [[String : AnyObject]]
            for item in favoriteList {
                if (item["committee_id"] as? String) == comid{
                    let yesFavorite: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "favorite_Fill")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.removeFavorite))
                    navigationItem.rightBarButtonItem = yesFavorite;
                    break
                }
                index = index + 1
            }
            if index >= favoriteList.count {
                let noFavorite: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "favorite")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.addFavorite))
                navigationItem.rightBarButtonItem = noFavorite;
            }
            
        }
        else{
            let noFavorite: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "favorite")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.addFavorite))
            navigationItem.rightBarButtonItem = noFavorite;
            
        }
        
        
        
        
        
        
        
        text.text = passedValue["name"] as? String
        
        let id = "ID                          \(passedValue["committee_id"] as! String)"
        datasource.append(id)
        
        var parent = ""
        if passedValue["parent_committee_id"] == nil {
            parent = "N.A."
        }
        else{
            parent = passedValue["parent_committee_id"] as! String
        }
        let Parent = "Parent ID              \(parent)"
        datasource.append(Parent)
        
        let chamber = "Chamber              \(passedValue["chamber"] as! String)"
        datasource.append(chamber)
        
        
        var office = ""
        if passedValue["office"] == nil {
            office = "N.A."
        }
        else{
            office = passedValue["office"] as! String
        }
        let Office = "Office                   \(office)"
        datasource.append(Office)
        
        
        
        var phone = ""
        if passedValue["phone"] == nil {
            phone = "N.A."
        }
        else{
            phone = passedValue["phone"] as! String
        }
        let Phone = "Contact                 \(phone)"
        datasource.append(Phone)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var text = datasource[indexPath.row]
        cell.textLabel?.text = text
        return cell
    }

    

}
