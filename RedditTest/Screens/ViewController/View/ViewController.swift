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
    private var isFetchingNextPage = false
    
    var posts = [SinglePost]()
    private let viewControllerPresenter = ViewControllerPresenter(viewControllerService: ViewControllerService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(nil, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)

        viewControllerPresenter.setViewDelegate(viewControllerDelegates: self)
     //   viewControllerPresenter.loadFromCoreData()
        viewControllerPresenter.loadNextPage(0)  //connect()
    }
    
    @objc func refresh(sender:AnyObject)
    {
        //viewControllerPresenter.connect()
        
        refreshControl.endRefreshing()
    }
    
    private func fetchNextPage() {
        guard !isFetchingNextPage else { return }
        viewControllerPresenter.loadNextPage(posts.count)
    }
}

extension ViewController: ViewControllerDelegates {
    func loadNextPage(_ posts: [SinglePost]) {
        isFetchingNextPage = false
        self.posts = posts
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func loadFromCoreData(_ posts: [SinglePost]) {
        self.posts = posts
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func connect(_ posts: [SinglePost]) {
        self.posts = posts
        DispatchQueue.main.async {
            self.tableView.reloadAnimated()
        }
    }
    
    func reloadData() {
        print("need to reload data")
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewControllerConsts.cell) as! ViewControllerCell

        cell.congigure(posts[indexPath.row], indexPath.row + 1)

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
}

extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print("prefetchRowsAt \(indexPaths)")
        let needsFetch = indexPaths.contains { $0.row >= self.posts.count - 1 }
        if needsFetch {
            fetchNextPage()
        }
        
      //  tableView.reloadData
    }

    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print("cancelPrefetchingForRowsAt \(indexPaths)")
    }
}

