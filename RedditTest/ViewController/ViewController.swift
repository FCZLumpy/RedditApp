//
//  ViewController.swift
//  RedditTest
//
//  Created by Oleksandr Balytskyi on 27.03.2020.
//  Copyright © 2020 Oleksandr Balytskyi. All rights reserved.
//

import UIKit

class ViewController: UIViewController  {
    
    private let viewControllerPresenter = ViewControllerPresenter(viewControllerService: ViewControllerService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllerPresenter.setViewDelegate(viewControllerDelegates: self)
        viewControllerPresenter.connect()
        // Do any additional setup after loading the view.
    }


}

extension ViewController: ViewControllerDelegates {
    func connect() {
        print("connected")
    }
    
    func reloadData() {
        print("need to reload data")
    }
}

