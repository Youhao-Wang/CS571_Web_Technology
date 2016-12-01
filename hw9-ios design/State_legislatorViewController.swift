//
//  State_legislatorViewController.swift
//  HW9_1
//
//  Created by 王优豪 on 11/19/16.
//  Copyright © 2016 Youhao-Wang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import AlamofireImage


class State_legislatorViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate {
    
    var refreshControl: UIRefreshControl!
    var dateFormatter = DateFormatter()
    
    var arrRes = [[String:AnyObject]]() //Array of dictionary
    var filteredData = [[String:AnyObject]]()
    var sections : [(index: Int, length :Int, title: String)] = Array()
    let items :[String] = ["All States" , "Alabama", "Alaska" ,"Arizona" ,"California","Colorado","Connecticut","Delaware" ,"District Of Columbia" ,"New York" , "New Mexico","Montana" , "Nebraska","Nevada", "New Hampshire" , "New Jersey" ,"North Carolina" ,"North Dakota" , "Washington", "Florida","Georgia", "Hawaii" ,"Idaho" ,"Illinois" ,"Indiana" ,"Iowa" ,"Kansas" ,"Kentucky" ,"Louisiana" ,"Maine" ,"Maryland" ,"Massachusetts" ,"Michigan" ,"Minnesota" ,"Mississippi" ,"Missouri" ,"Ohii" ,"Oklahoma" ,"Oregon" ,"Pennsylvania" ,"Rhode Island" ,"South Carolina","South Dakota","Tennessee","Texas","Utah" ,"Vermont","Virginia","West Virginia","Wisconsin" ,"Wyoming", "text"]
    var selected = ""
    

    @IBOutlet weak var stateTable: UITableView!
    @IBOutlet weak var picker: UIPickerView!
    
    
    override func viewDidLoad() {
        //SwiftSpinner.show(duration: 2.0, title: "Fetching data...")
        SwiftSpinner.show("Fetching data...")
        super.viewDidLoad()
        UrlRequest()
        
        self.dateFormatter.dateStyle = .short
        self.dateFormatter.timeStyle = .long
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        self.stateTable.addSubview(refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.titleView = nil
        self.tabBarController?.navigationItem.title = "Legislators"
        let filterBarButton: UIBarButtonItem = UIBarButtonItem(title :"Filter", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.makefilter))
        self.tabBarController?.navigationItem.rightBarButtonItem = filterBarButton;
        
    }
    
    
    func refresh(sender:AnyObject) {
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
       SwiftSpinner.show(duration: 2.0, title: "Fetching data...")
       self.filteredData = self.arrRes
       //arrRes = [[String:AnyObject]]()
       sections = []
       MakeIndex()
        let now = NSDate()
        let updateString = "Last Updated at " + self.dateFormatter.string(from: now as Date)
        self.refreshControl.attributedTitle = NSAttributedString(string: updateString)
        self.refreshControl.endRefreshing()
    }
    
    
    
    

    func makefilter(){
        self.stateTable.isHidden = true;
        let DoneBarButton: UIBarButtonItem = UIBarButtonItem(title :"Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.endSelected))
        self.tabBarController?.navigationItem.rightBarButtonItem = DoneBarButton;
        
    }
    
    
    func endSelected(){
        self.stateTable.isHidden = false;
        //SwiftSpinner.show(duration: 1.5, title: "Fetching data...")
        SwiftSpinner.show("Fetching data...")
        if selected == "All States"{
            selected = ""
            self.filteredData = self.arrRes
        }
        else{
            self.filteredData = self.arrRes.filter {
                ($0["state_name"] as? String) ==  selected }
        }
        sections = []
        MakeIndex()
        let filterBarButton: UIBarButtonItem = UIBarButtonItem(title :"Filter", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.makefilter))
        self.tabBarController?.navigationItem.rightBarButtonItem = filterBarButton;
        //self.stateTable.reloadData()
    }
    
    

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected = items[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }

    func UrlRequest() {
      let awsurl = "http://youhao.eypfwwr7rx.us-west-2.elasticbeanstalk.com"
      let parameters: Parameters = ["type": 1]
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
                self.filteredData = self.arrRes
                self.MakeIndex()
            }
        }
    }
    
    
    
    func MakeIndex() {
        if self.filteredData.count > 0 {
            self.filteredData.sort{   let first1 = $0["first_name"] as? String
                let first2 = $1["first_name"] as? String
                let last1 = $0["last_name"] as? String
                let last2 = $1["last_name"] as? String
                if first1 == first2 {
                    return last1! < last2! }
                else {
                    return first1! < first2!
                }
            }
            var index = 0;
            for var i in (0..<self.filteredData.count) {
            
                let commonPrefix = (self.filteredData[i]["first_name"]as! String).commonPrefix(with: (self.filteredData[index]["first_name"]as! String), options: .caseInsensitive)
                if (commonPrefix.isEmpty) {
                    let string = (self.filteredData[index]["first_name"]as! String).uppercased();
                    let firstCharacter = string[string.startIndex]
                    let title = "\(firstCharacter)"
                    let newSection = (index: index, length: i - index, title: title)
                    self.sections.append(newSection)
                    index = i;
            }
        }
        }
            self.stateTable.reloadData()
            SwiftSpinner.hide()
    }
}



extension State_legislatorViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].length
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
        //return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "legislator_cell", for: indexPath)
        var dict = filteredData[sections[indexPath.section].index + indexPath.row]
        //var dict = arrRes[(indexPath as NSIndexPath).row]
        var text = ""
        
        text = ((dict["first_name"]) as? String)!
        text += " " + ((dict["last_name"]) as? String)!
        cell.textLabel?.text = text
        
        cell.detailTextLabel?.text = dict["state_name"] as? String
        let bioId = dict["bioguide_id"] as? String
        
       let url = NSURL(string: "https://theunitedstates.io/images/congress/225x275/\(bioId!).jpg")
         
        if sections[indexPath.section].index + indexPath.row < 14 {
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
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int{
        return index
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections.map { $0.title }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.font = UIFont(name: "Futura", size: 20)!
    }
    
    private func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28.0
    }
    
    
    
    
    
}




extension State_legislatorViewController : UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow;
        let dict = filteredData[(sections[(indexPath?.section)!].index + (indexPath?.row)!)]
        
        let storyboard = UIStoryboard(name: "LegislatorDetail", bundle: nil)
        let LegislatorDetail = storyboard.instantiateViewController(withIdentifier: "LegislatorDetail_ViewController") as! LegislatorDetail_ViewController
        LegislatorDetail.passedValue = dict
        self.navigationController?.pushViewController(LegislatorDetail, animated: true)
        
    }
}
