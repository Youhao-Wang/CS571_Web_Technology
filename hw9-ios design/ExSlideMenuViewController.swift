//
//  ExSlideMenuViewController.swift
//  HW9_1
//
//  Created by 王优豪 on 11/18/16.
//  Copyright © 2016 Youhao-Wang. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class ExSlideMenuController: SlideMenuController {
    override func isTagetViewController() -> Bool {
        if let vc = UIApplication.topViewController() {
            if vc is LegislatorViewController ||
                vc is BillViewController ||
                vc is CommitteeViewController ||
                vc is FavoriteViewController ||
                vc is AboutViewController {
                return true
            }
        }
        
        return false
    }
}
