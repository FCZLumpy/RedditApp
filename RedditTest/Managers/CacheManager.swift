import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImageUsingCache(_ urlString: String?) {
        guard let nsstr = urlString as NSString? else { return }
        guard let tmpUrl = urlString, let url = URL(string: tmpUrl) else { return }
        self.image = nil

        // check cached image
        if let cachedImage = imageCache.object(forKey: nsstr) {
            self.image = cachedImage
            return
        }

        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .gray)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = self.center

        // if not, download image from url
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    activityIndicator.removeFromSuperview()
                }
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: nsstr)
                    self.image = image
                    activityIndicator.removeFromSuperview()
                }
            }
        }).resume()
    }
}
