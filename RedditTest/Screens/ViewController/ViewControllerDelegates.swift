//
//  ViewControllerDelegates.swift
//  RedditTest
//
//  Created by Oleksandr Balytskyi on 27.03.2020.
//  Copyright © 2020 Oleksandr Balytskyi. All rights reserved.
//

import Foundation

protocol ViewControllerDelegates: NSObjectProtocol {
    func loadFromCoreData(_ posts: [SinglePost])
    func reloadData(_ posts: [SinglePost])
    func loadNextPage(_ posts: [SinglePost])
}
