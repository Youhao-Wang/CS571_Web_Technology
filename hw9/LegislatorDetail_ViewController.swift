//
//  LegislatorDetail_ViewController.swift
//  HW9_1
//
//  Created by 王优豪 on 11/19/16.
//  Copyright © 2016 Youhao-Wang. All rights reserved.
//

import UIKit

class LegislatorDetail_ViewController: UIViewController,UITableViewDataSource {

    var passedValue = [String:Any]()
    var datasource = [String]()
    var twitterurl = ""
    var firstname = ""
    var lastname = ""
    
    var favoriteLegislator = [[String:Any]]()
    var index = 0
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var table: UITableView!
    
    var sharebtn: UIBarButtonItem! = nil
    var img: UIImage!
    
    
    
    func share(){
        let messageStr: String = (passedValue["first_name"]as! String) + " " + (passedValue["last_name"]as! String)
        let messageUrl: NSURL  = NSURL(string: (passedValue["website"]as! String) )!
        let shareItems:Array = [img, messageUrl, messageStr] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
    }

    
    
    func addFavorite() {
        let yesFavorite: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "favorite_Fill")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.removeFavorite))
        navigationItem.rightBarButtonItems = [sharebtn,yesFavorite];
        
        let keysToRemove = passedValue.nullKeyRemoval()
        favoriteLegislator.append(keysToRemove)
        UserDefaults.standard.set(favoriteLegislator, forKey: "favoriteLegislator")
        UserDefaults.standard.synchronize()
    }
    
    func removeFavorite() {
        let noFavorite: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "favorite")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.addFavorite))
        navigationItem.rightBarButtonItems = [sharebtn,noFavorite];
        favoriteLegislator.remove(at: index)
        index = favoriteLegislator.count
        UserDefaults.standard.set(favoriteLegislator, forKey: "favoriteLegislator")
        UserDefaults.standard.synchronize()
    }
    
    
    
     override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Legislator Details"
        let bioId = passedValue["bioguide_id"] as? String
        sharebtn = UIBarButtonItem(image: UIImage(named: "share")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.share))
        
        
        if let favoriteList = UserDefaults.standard.array(forKey: "favoriteLegislator") as? [[String: Any]] {
            favoriteLegislator = favoriteList
             for item in favoriteList {
                if (item["bioguide_id"] as? String) == bioId{
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
            navigationItem.rightBarButtonItems = [sharebtn,noFavorite];

        }
        //UserDefaults.standard.removeObject(forKey: "favoriteLegislator")
      
        
        
        twitterurl = ""
        let twitterid = passedValue["twitter_id"] as? String
        if twitterid == nil{
            twitterurl = "http://twitter.com/"
        }
        else{
            twitterurl = "http://twitter.com/" + (passedValue["twitter_id"] as? String)!
        }
        
        let url = NSURL(string: "https://theunitedstates.io/images/congress/225x275/\(bioId!).jpg")
        if let data = NSData(contentsOf: url! as URL)
        {
            if let deimage = UIImage(data: data as Data){
                image.image = deimage
                img = deimage
            }
        }
        
        
        firstname = "First Name          \(passedValue["first_name"] as! String)"
        datasource.append(firstname)
        lastname = "Last Name          \(passedValue["last_name"] as! String)"
        datasource.append(lastname)
        let state = "State                   \(passedValue["state_name"] as! String)"
        datasource.append(state)
        
       
    
        let birth = DateFormatter()
        birth.dateFormat = "yyyy-MM-dd"
        let date = birth.date(from: (passedValue["birthday"] as! String))
        birth.dateFormat = "dd MMM, YYYY"
        let birthday = birth.string(from: date!)
        datasource.append("Birth date           \(birthday)")
        
        let g = passedValue["last_name"] as! String
        var gender = ""
        if g == "M"{
            gender = "Male"
        }
        else{
            gender = "Female"
        }
        let gen = "Gender               \(gender)"
        datasource.append(gen)
        
        let chamber = "Chamber            \(passedValue["chamber"] as! String)"
        datasource.append(chamber)
        
        let f = passedValue["fax"] as? String
        var fax = ""
        if f == nil {
            fax = "N.A."
        }
        else{
            fax = passedValue["fax"] as! String
        }
        let Fax = "Fax NO.              \(fax)"
        datasource.append(Fax)
        datasource.append("Twitter")
        datasource.append("Website")
        
        let office = "Office NO.          \(passedValue["office"] as! String)"
        datasource.append(office)
        
        let termformate = DateFormatter()
        termformate.dateFormat = "yyyy-MM-dd"
        let termdate = termformate.date(from: (passedValue["term_end"] as! String))
        termformate.dateFormat = "dd MMM, YYYY"
        let term = termformate.string(from: termdate!)
        datasource.append("Term ends on    \(term)")
        

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
        let text = datasource[indexPath.row]
        cell.textLabel?.text = text
        if indexPath.row == 7 {
            let btn = UIButton()
            btn.setTitle("Twitter Link", for : .normal)
            btn.setTitleColor(UIColor.blue, for: .normal)
            btn.frame = CGRect(x : self.view.frame.size.width-246, y : 0, width: 100, height: 40)
            btn.addTarget(self, action: #selector(linktoTwitter), for: .touchUpInside)
            cell.addSubview(btn)
        }
        
        if indexPath.row == 8 {
            let btn = UIButton()
            btn.setTitle("Website Link", for : .normal)
            btn.setTitleColor(UIColor.blue, for: .normal)
            btn.frame = CGRect(x : self.view.frame.size.width-265, y : 0, width: 150, height: 40)
            btn.addTarget(self, action: #selector(linktoWeb), for: .touchUpInside)
            cell.addSubview(btn)

        }
        return cell
    }
    
    func linktoTwitter(){
        let alertController = UIAlertController(title: nil, message: "Open \(passedValue["first_name"] as! String) \(passedValue["last_name"] as! String)'s Twitter Link", preferredStyle: .actionSheet)
        
        let openAction = UIAlertAction(title: "Open in Safari", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            UIApplication.shared.openURL(URL(string: self.twitterurl)!)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            return
        })
        
         alertController.addAction(openAction)
         alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func linktoWeb(){
        let alertController = UIAlertController(title: nil, message: "Open \(passedValue["first_name"] as! String) \(passedValue["last_name"] as! String)'s Website Link", preferredStyle: .actionSheet)
        
        let openAction = UIAlertAction(title: "Open in Safari", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            UIApplication.shared.openURL(URL(string: (self.passedValue["website"]as! String) )!)
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




