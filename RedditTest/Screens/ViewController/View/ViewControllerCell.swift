import UIKit

class ViewControllerCell: UITableViewCell {
    @IBOutlet weak var tlTitle: UILabel!
    @IBOutlet weak var tlAuthor: UILabel!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var tlComments: UILabel!
    
    var saveImageFinished: () -> () = {}
    
    public func congigure(_ post: SinglePost, _ index: Int) {
        tlTitle.text = post.title
        let date = convertDate(post.created)
        tlAuthor.text = "\(post.authorName) \(date)"
        ivImage.loadImageUsingCache(post.thumbnailURL)
        tlComments.text = "\(post.commentsCount) comments"
        
        let tap = GestureRecognizerWithParam(target: self, action: #selector(tapHandler))
        //Here should be imageURL from preview, but I dont know why I receive 403 in app and in Safary
        tap.url = post.thumbnailURL //post.imageURL
        ivImage?.addGestureRecognizer(tap)
        ivImage?.isUserInteractionEnabled = true
        
        let longTap = LongGestureRecognizerWithParam(target: self, action: #selector(longTapHandler))
        longTap.url = post.thumbnailURL //post.imageURL
        ivImage?.addGestureRecognizer(longTap)
        ivImage?.isUserInteractionEnabled = true
    }
    
    @objc func tapHandler(sender: GestureRecognizerWithParam)
    {
        guard let url = URL(string: sender.url) else { return  }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func longTapHandler(sender: LongGestureRecognizerWithParam)
    {
        guard sender.state != UIGestureRecognizer.State.ended else { return }
        guard let url = URL(string: sender.url) else { return  }

        getDataFromUrl(url: url) { (data, response, error) in

            guard let data = data, let imageFromData = UIImage(data: data) else { return }

            DispatchQueue.main.async() {
                UIImageWriteToSavedPhotosAlbum(imageFromData, nil, nil, nil)
                self.saveImageFinished()
            }
        }
    }
    
    private func convertDate(_ date: Int?) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(date ?? 0))
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let relativeDate = formatter.localizedString(for: date, relativeTo: Date())
        
        return relativeDate
    }
    
    private func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
        }.resume()
    }
}
