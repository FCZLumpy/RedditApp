//
//  ViewController.swift
//  RedditTest
//
//  Created by Oleksandr Balytskyi on 27.03.2020.
//  Copyright © 2020 Oleksandr Balytskyi. All rights reserved.
//

import UIKit

class ViewController: UIViewController  {
    
    @IBOutlet weak var tableView: UITableView!
    lazy var refreshControl = UIRefreshControl()
    
    var posts = [PostData]()
    private let viewControllerPresenter = ViewControllerPresenter(viewControllerService: ViewControllerService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)

        viewControllerPresenter.setViewDelegate(viewControllerDelegates: self)
        viewControllerPresenter.connect()
    }
    
    @objc func refresh(sender:AnyObject)
    {
        viewControllerPresenter.connect()
        refreshControl.endRefreshing()
    }
}

extension ViewController: ViewControllerDelegates {
    func connect(_ posts: [PostData]) {
        self.posts = posts
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func reloadData() {
        print("need to reload data")
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewControllerConsts.cell) as! ViewControllerCell

        cell.congigure(posts[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
}

