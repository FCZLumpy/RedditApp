//
//  ViewControllerService.swift
//  RedditTest
//
//  Created by Oleksandr Balytskyi on 27.03.2020.
//  Copyright © 2020 Oleksandr Balytskyi. All rights reserved.
//

import Foundation

class ViewControllerService {
    func connect(callback: (Bool) -> Void) {
        print("connect")
        callback(true)
    }
    
    func reloadData(callback: (Bool) -> Void) {
        print("reload data")
        callback(true)
    }
    
    
}
