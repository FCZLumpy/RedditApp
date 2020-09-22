import UIKit
import CoreData

class ViewControllerService {
    
    var posts = [SinglePost]()
    
    func loadFromCoreData(callback: @escaping([SinglePost]) -> Void) {
        callback(fetchFromCoreData())
    }
    
    func reloadData(callback: @escaping([SinglePost]) -> Void) {
        guard let url = URL(string: ViewControllerConsts.redditURL) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                callback(self.posts)
                return
            }
            do {
                let decoder = JSONDecoder()
                let topData = try decoder.decode(TopData.self, from: data)
                self.posts = topData.topData.children.map { $0.data }
                
                DispatchQueue.main.async {
                    self.saveToCoreData(self.posts)
                }
                       
                callback(self.posts)
                       
            } catch {
                callback([])
                print("json error: \(error)")
            }
        }
        task.resume()
    }
    
    func loadNextPage(callback: @escaping([SinglePost]) -> Void) {
        let last = posts.last?.name ?? ""
        guard var url = URLComponents(string: ViewControllerConsts.redditURL) else { return }
        url.queryItems = [ URLQueryItem(name: ViewControllerConsts.currentCount, value: last),
                           URLQueryItem(name: ViewControllerConsts.limit, value: ViewControllerConsts.pageSize) ]
        
        guard let tmpUrl = url.url else { return }
        let task = URLSession.shared.dataTask(with: tmpUrl) { (data, response, error) in
            guard let data = data else {
                callback(self.posts)
                return
            }
            do {
                let decoder = JSONDecoder()
                let topData = try decoder.decode(TopData.self, from: data)
                let singlePosts = topData.topData.children.map { $0.data }
                self.posts.append(contentsOf: singlePosts)
                DispatchQueue.main.async {
                    self.saveToCoreData(singlePosts)
                }
                       
                callback(self.posts)
                       
            } catch {
                callback([])
                print("json error: \(error)")
            }
        }
        task.resume()
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
            post.setValue(singlePost.name, forKeyPath: ViewControllerConsts.name)
            post.setValue(singlePost.imageURL, forKey: ViewControllerConsts.imageURL)
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    private func fetchFromCoreData() -> [SinglePost] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: ViewControllerConsts.singlePost)
        do {
            let post = try managedContext.fetch(fetchRequest)
            var postsFromCoreData = [SinglePost]()
            for tmpPost in post {
                let tmpSinglePost = SinglePost(authorName: tmpPost.value(forKey: ViewControllerConsts.authorName) as! String, title: tmpPost.value(forKey: ViewControllerConsts.title) as! String, thumbnailURL: tmpPost.value(forKey: ViewControllerConsts.thumbnailURL) as! String, created: tmpPost.value(forKey: ViewControllerConsts.created) as! Int, commentsCount: tmpPost.value(forKey: ViewControllerConsts.commentsCount) as! Int, name: tmpPost.value(forKey: ViewControllerConsts.name) as! String, imageURL: tmpPost.value(forKey: ViewControllerConsts.imageURL) as! String)
                postsFromCoreData.append(tmpSinglePost)
            }
            return postsFromCoreData
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
}
