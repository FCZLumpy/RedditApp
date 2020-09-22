import UIKit

extension UITableView {
    func reloadAnimated() {
        let range = NSMakeRange(0, numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        self.reloadSections(sections as IndexSet, with: .automatic)
    }
}
