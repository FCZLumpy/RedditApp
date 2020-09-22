import Foundation

protocol ViewControllerDelegates: NSObjectProtocol {
    func loadFromCoreData(_ posts: [SinglePost])
    func reloadData(_ posts: [SinglePost])
    func loadNextPage(_ posts: [SinglePost])
}
