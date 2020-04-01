//
//  Extensions.swift
//  RedditTest
//
//  Created by Elina Balytska on 29.03.2020.
//  Copyright © 2020 Oleksandr Balytskyi. All rights reserved.
//

import UIKit

extension UITableView {
    func reloadAnimated() {
        let range = NSMakeRange(0, numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        self.reloadSections(sections as IndexSet, with: .automatic)
    }
}
