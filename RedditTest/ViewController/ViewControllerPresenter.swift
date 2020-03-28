//
//  ViewControllerPresenter.swift
//  RedditTest
//
//  Created by Oleksandr Balytskyi on 27.03.2020.
//  Copyright © 2020 Oleksandr Balytskyi. All rights reserved.
//

import Foundation

class ViewControllerPresenter {
    private let viewControllerService: ViewControllerService
    weak private var viewControllerDelegates: ViewControllerDelegates?
    
    init(viewControllerService: ViewControllerService) {
        self.viewControllerService = viewControllerService
    }
    
    func setViewDelegate(viewControllerDelegates: ViewControllerDelegates?) {
        self.viewControllerDelegates = viewControllerDelegates
    }
    
    func connect() {
        viewControllerService.connect() { value in
            self.viewControllerDelegates?.connect(value)
        }
    }
    
    func reloadData()  {
        viewControllerService.reloadData() { value in
            viewControllerDelegates?.reloadData()
        }
    }
}
