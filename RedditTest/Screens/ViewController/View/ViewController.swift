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
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    lazy var refreshControl = UIRefreshControl()
    private var isFetchingNextPage = false
    
    var posts = [SinglePost]()
    private let viewControllerPresenter = ViewControllerPresenter(viewControllerService: ViewControllerService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    
        viewControllerPresenter.setViewDelegate(viewControllerDelegates: self)
        
        viewControllerPresenter.loadFromCoreData()
        viewControllerPresenter.loadNextPage()
    }
    
    @objc func refresh(sender:AnyObject)
    {
        viewControllerPresenter.reloadData()
        refreshControl.endRefreshing()
    }
    
    private func setupUI() {
        tableView.tableFooterView = UIView()
        refreshControl.addTarget(nil, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        spinner.startAnimating()
    }
    
    private func fetchNextPage() {
        guard !isFetchingNextPage else { return }
        viewControllerPresenter.loadNextPage()
    }
    
    private func showWarningEmptyData() {
        let alert = UIAlertController(title: ViewControllerConsts.warning, message: ViewControllerConsts.dataIsEmpty, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: ViewControllerConsts.retry, style: .default, handler: { action in
            self.viewControllerPresenter.loadNextPage()
        } ))
        alert.addAction(UIAlertAction(title: ViewControllerConsts.cancel, style: .cancel, handler: { action in
            self.spinner.stopAnimating()
        }))

        self.present(alert, animated: true)
    }
    
    private func showWarningSavedImage() {
        let alert = UIAlertController(title: ViewControllerConsts.imageSaved, message: ViewControllerConsts.clickTocontinue, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: ViewControllerConsts.ok, style: .default, handler: nil ))

        self.present(alert, animated: true)
    }
}

extension ViewController: ViewControllerDelegates {
    func reloadData(_ posts: [SinglePost]) {
        showPosts(posts)
    }
    
    func loadNextPage(_ posts: [SinglePost]) {
        showPosts(posts)
    }
    
    func loadFromCoreData(_ posts: [SinglePost]) {
        spinner.stopAnimating()
        self.posts = posts
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func showPosts(_ posts: [SinglePost]) {
        if posts.isEmpty {
            DispatchQueue.main.async {
                self.showWarningEmptyData()
            }
        } else {
            isFetchingNextPage = false
            self.posts = posts
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewControllerConsts.cell) as! ViewControllerCell

        cell.congigure(posts[indexPath.row], indexPath.row + 1)
        cell.saveImageFinished = {
            self.showWarningSavedImage()
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
}

extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let needsFetch = indexPaths.contains { $0.row >= self.posts.count - 1 }
        if needsFetch {
            fetchNextPage()
        }
    }
}

