//
//  LeftViewController.swift
//  HW9_1
//
//  Created by 王优豪 on 11/18/16.
//  Copyright © 2016 Youhao-Wang. All rights reserved.
//

import UIKit

enum LeftMenu: Int {
    case Legislator = 0
    case Bill
    case Committee
    case Favorite
    case About
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftViewController : UIViewController, LeftMenuProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    var menus = ["Legislator", "Bill", "Committee", "Favorite", "About"]
    var LegislatorViewController: UIViewController!
    var BillViewController: UIViewController!
    var CommitteeViewController: UIViewController!
    var FavoriteViewController: UIViewController!
    var AboutViewController: UIViewController!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor(hex: "f4ffed")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let LegislatorViewController = storyboard.instantiateViewController(withIdentifier: "LegislatorViewController") as! LegislatorViewController
        self.LegislatorViewController = UINavigationController(rootViewController: LegislatorViewController)
        
        
        
        let BillViewController = storyboard.instantiateViewController(withIdentifier: "BillViewController") as! BillViewController
        self.BillViewController = UINavigationController(rootViewController: BillViewController)
        
        let CommitteeViewController = storyboard.instantiateViewController(withIdentifier: "CommitteeViewController") as! CommitteeViewController
        self.CommitteeViewController = UINavigationController(rootViewController: CommitteeViewController)
        
        let FavoriteViewController = storyboard.instantiateViewController(withIdentifier: "FavoriteViewController") as! FavoriteViewController
        self.FavoriteViewController = UINavigationController(rootViewController: FavoriteViewController)
        
        
        let AboutViewController = storyboard.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
        self.AboutViewController = UINavigationController(rootViewController: AboutViewController)

        
        
        self.tableView.registerCellClass(BaseTableViewCell.self)
        
        //self.imageHeaderView = ImageHeaderView.loadNib()
        //self.view.addSubview(self.imageHeaderView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //self.imageHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160)
        self.view.layoutIfNeeded()
    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .Legislator:
            self.slideMenuController()?.changeMainViewController(self.LegislatorViewController, close: true)
        case .Bill:
            self.slideMenuController()?.changeMainViewController(self.BillViewController, close: true)
        case .Committee:
            self.slideMenuController()?.changeMainViewController(self.CommitteeViewController, close: true)
        case .Favorite:
            self.slideMenuController()?.changeMainViewController(self.FavoriteViewController, close: true)
        case .About:
            self.slideMenuController()?.changeMainViewController(self.AboutViewController, close: true)
        }
    }
}

extension LeftViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .Legislator, .Bill, .Committee, .Favorite, .About:
                return BaseTableViewCell.height()
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            self.changeViewController(menu)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}

extension LeftViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .Legislator, .Bill, .Committee, .Favorite, .About:
                let cell = BaseTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                cell.setData(menus[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
}
