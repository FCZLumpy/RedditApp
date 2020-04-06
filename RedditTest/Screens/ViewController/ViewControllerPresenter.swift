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
    
    func loadFromCoreData() {
        viewControllerService.loadFromCoreData() { value in
            self.viewControllerDelegates?.loadFromCoreData(value)
        }
    }
    
    func reloadData()  {
        viewControllerService.reloadData() { value in
            self.viewControllerDelegates?.reloadData(value)
        }
    }
    
    func loadNextPage() {
        viewControllerService.loadNextPage() { value in
            self.viewControllerDelegates?.loadNextPage(value)
        }
    }
}
