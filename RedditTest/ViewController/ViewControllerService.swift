//
//  ViewControllerService.swift
//  RedditTest
//
//  Created by Oleksandr Balytskyi on 27.03.2020.
//  Copyright © 2020 Oleksandr Balytskyi. All rights reserved.
//

import UIKit
import CoreData

class ViewControllerService {
    
    
    func connect(callback: @escaping([SinglePost]) -> Void) {
        guard let url = URL(string: ViewControllerConsts.redditURL) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let topData = try decoder.decode(TopData.self, from: data)
                let singlePosts = topData.topData.children.map { $0.data }
                DispatchQueue.main.async {
                    self.saveToCoreData(singlePosts)
                }
                
                callback(singlePosts )
                
            } catch {
                callback([])
                print("json error: \(error)")
            }
        }
        
        task.resume()
    }
    
    func loadFromCoreData(callback: @escaping([SinglePost]) -> Void) {
        callback(fetchFromCoreData() ?? [])
    }
    
    func reloadData(callback: (Bool) -> Void) {
        print("reload data")
        
        fetchFromCoreData()
        callback(true)
    }
    
    private func saveToCoreData(_ singlePosts: [SinglePost]?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: ViewControllerConsts.singlePost, in: managedContext)!
        
        for singlePost in singlePosts ?? [] {
            let post = NSManagedObject(entity: entity, insertInto: managedContext)
            post.setValue(singlePost.authorName, forKeyPath: ViewControllerConsts.authorName)
            post.setValue(singlePost.commentsCount, forKeyPath: ViewControllerConsts.commentsCount)
            post.setValue(singlePost.created, forKeyPath: ViewControllerConsts.created)
            post.setValue(singlePost.title, forKeyPath: ViewControllerConsts.title)
            post.setValue(singlePost.thumbnailURL, forKeyPath: ViewControllerConsts.thumbnailURL)
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    private func fetchFromCoreData() -> [SinglePost]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: ViewControllerConsts.singlePost)
        do {
            let post = try managedContext.fetch(fetchRequest)
            var postsFromCoreData = [SinglePost]()
            for tmpPost in post {
                let tmpSinglePost = SinglePost(authorName: tmpPost.value(forKey: ViewControllerConsts.authorName) as! String, title: tmpPost.value(forKey: ViewControllerConsts.title) as! String, thumbnailURL: tmpPost.value(forKey: ViewControllerConsts.thumbnailURL) as! String, created: tmpPost.value(forKey: ViewControllerConsts.created) as! Int, commentsCount: tmpPost.value(forKey: ViewControllerConsts.commentsCount) as! Int)
                postsFromCoreData.append(tmpSinglePost)
            }
            return postsFromCoreData
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
}


