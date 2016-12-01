//
//  BillDetailViewController.swift
//  HW9_1
//
//  Created by 王优豪 on 11/22/16.
//  Copyright © 2016 Youhao-Wang. All rights reserved.
//

import UIKit

class BillDetailViewController: UIViewController,UITableViewDataSource  {
    @IBOutlet weak var text: UITextView!
    @IBOutlet weak var table: UITableView!
    
    var passedValue = [String:AnyObject]()
    var datasource = [String]()
    var url = ""
    
    var favoriteLegislator = [[String:AnyObject]]()
    var index = 0
    
    
    
    var sharebtn: UIBarButtonItem! = nil
    
    func share(){
        let messageStr: String = (passedValue["bill_id"]as! String)
        let messageUrl: NSURL  = NSURL(string: url)!
        let shareItems:Array = [messageUrl, messageStr] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
    }

    
    
    
    
    func addFavorite() {
        let yesFavorite: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "favorite_Fill")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.removeFavorite))
        navigationItem.rightBarButtonItems = [sharebtn,yesFavorite];

        
        var keysToRemove = passedValue.nullKeyRemoval()
         for (key,value) in keysToRemove{
        if value is Dictionary<String, AnyObject>{
                var temp = [String:AnyObject]()
                temp = value as! [String : AnyObject]
                temp = temp.nullKeyRemoval()
                keysToRemove[key] = temp as AnyObject?
            }
        }
        
        
        favoriteLegislator.append(keysToRemove)
        UserDefaults.standard.set(favoriteLegislator, forKey: "favoriteBill")
        UserDefaults.standard.synchronize()
    }
    
    func removeFavorite() {
        let noFavorite: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "favorite")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.addFavorite))
        navigationItem.rightBarButtonItems = [sharebtn,noFavorite];

        favoriteLegislator.remove(at: index)
        index = favoriteLegislator.count
        UserDefaults.standard.set(favoriteLegislator, forKey: "favoriteBill")
        UserDefaults.standard.synchronize()
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         navigationItem.title = "Bill Details"
         sharebtn = UIBarButtonItem(image: UIImage(named: "share")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.share))
        
        
        let billid = passedValue["bill_id"] as! String
        if let favoriteList = UserDefaults.standard.array(forKey: "favoriteBill") as? [[String: Any]] {
            favoriteLegislator = favoriteList as [[String : AnyObject]]
            for item in favoriteList {
                if (item["bill_id"] as? String) == billid{
                    let yesFavorite: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "favorite_Fill")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.removeFavorite))
                    navigationItem.rightBarButtonItems = [sharebtn,yesFavorite]
                    break
                }
                index = index + 1
            }
            if index >= favoriteList.count {
                let noFavorite: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "favorite")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.addFavorite))
                 navigationItem.rightBarButtonItems = [sharebtn,noFavorite]
            }
            
        }
        else{
            let noFavorite: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "favorite")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.addFavorite))
            navigationItem.rightBarButtonItems = [sharebtn,noFavorite]
        }
        
        
        
        
        
        text.text = passedValue["official_title"] as? String
        
        let id = "Bill ID                  \(passedValue["bill_id"] as! String)"
        datasource.append(id)
        var type = "Bill Type         \(passedValue["bill_type"] as! String)"
        type = type.uppercased()
        datasource.append(type)
        
        var sponsor = ""
        let ds = (passedValue["sponsor"] as? Dictionary<String, AnyObject>)!
        sponsor += "Sponsor             \(ds["title"] as! String)"
        sponsor += " \(ds["first_name"] as! String)"
        sponsor += " \(ds["last_name"] as! String)"
        datasource.append(sponsor)
        
        let t = passedValue["last_action_at"] as? String
        var time = ""
        if t == nil {
            time = "N.A."
        }
        else{
            let termformate = DateFormatter()
            termformate.dateFormat = "yyyy-MM-dd"
            let termdate = termformate.date(from: (passedValue["last_action_at"] as! String))
            if termdate == nil {
                time = t!
            }
            else{
                termformate.dateFormat = "dd MMM, YYYY"
                time = termformate.string(from: termdate!)
            }
        }
        let Time = "Lat Action          \(time)"
        datasource.append(Time)
        
        let chamber = "Chamber            \(passedValue["chamber"] as! String)"
        datasource.append(chamber)
        datasource.append("PDF")
        
        let v = passedValue["last_vote_at"] as? String
        var vote = ""
        if v == nil {
            vote = "N.A."
        }
        else{
            let voteformate = DateFormatter()
            voteformate.dateFormat = "yyyy-MM-dd"
            let votedate = voteformate.date(from: (passedValue["last_vote_at"] as! String))
            if votedate == nil {
                vote = v!
            }
            else{
                voteformate.dateFormat = "dd MMM, YYYY"
                vote = voteformate.string(from: votedate!)
            }
        }
        let Vote = "Last Vote            \(vote)"
        datasource.append(Vote)
        
        
        let history = (passedValue["history"] as? Dictionary<String, AnyObject>)!
        let s = history["active"] as! Bool
        var status = ""
        if s == true{
            status = "Active"
        }
        else{
            status = "New"
        }
        let gen = "Status                  \(status)"
        datasource.append(gen)

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
        if indexPath.row == 5 {
            
            if passedValue["last_version"] == nil{
                text += "                    N.A."
            }
                
            else{
                let h1 = (passedValue["last_version"] as? Dictionary<String, AnyObject>)!
                let h2 = (h1["urls"] as? Dictionary<String, AnyObject>)!
                url = (h2["pdf"] as? String)!
                if url == nil{
                    text += "                    N.A."
                }
                else{
                    let btn = UIButton()
                    btn.setTitle("PDF Link", for : .normal)
                    btn.setTitleColor(UIColor.blue, for: .normal)
                    btn.frame = CGRect(x : self.view.frame.size.width-250, y : 0, width: 100, height: 40)
                    btn.addTarget(self, action: #selector(linktoPDF), for: .touchUpInside)
                    cell.addSubview(btn)
                }
            }
        }
        cell.textLabel?.text = text

        return cell
    }
    
    
    
    
    
    
    func linktoPDF(){
        let alertController = UIAlertController(title: nil, message: "Open \(passedValue["bill_id"] as! String)'s PDF Link", preferredStyle: .actionSheet)
        
        let openAction = UIAlertAction(title: "Open PDF in Safari", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            UIApplication.shared.openURL(URL(string: self.url)!)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            return
        })
        
        alertController.addAction(openAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    

}




