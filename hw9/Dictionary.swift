//
//  Dictionary.swift
//  HW9_1
//
//  Created by 王优豪 on 11/26/16.
//  Copyright © 2016 Youhao-Wang. All rights reserved.
//

import UIKit

extension Dictionary {
    func nullKeyRemoval() -> Dictionary {
        var dict = self
        
        let keysToRemove = dict.keys.filter { dict[$0] is NSNull }
        for key in keysToRemove {
            dict.removeValue(forKey: key)
        }
        
        return dict
    }
}
