//
//  UIViewController.swift
//  HW9_1
//
//  Created by 王优豪 on 11/18/16.
//  Copyright © 2016 Youhao-Wang. All rights reserved.
//

import UIKit

extension UIViewController {
    
    
    
    func setNavigationBarItem() {
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
        
        self.slideMenuController()?.removeLeftGestures()

        self.slideMenuController()?.addLeftGestures()

    }
 
    
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
       // self.navigationItem.rightBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
        //self.slideMenuController()?.removeRightGestures()
    }
}
