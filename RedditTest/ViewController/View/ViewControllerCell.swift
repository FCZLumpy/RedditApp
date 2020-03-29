//
//  ViewControllerCell.swift
//  RedditTest
//
//  Created by Elina Balytska on 29.03.2020.
//  Copyright © 2020 Oleksandr Balytskyi. All rights reserved.
//

import UIKit

class ViewControllerCell: UITableViewCell {
    @IBOutlet weak var tlTitle: UILabel!
    @IBOutlet weak var tlAuthor: UILabel!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var tlComments: UILabel!
    
    public func congigure(_ post: PostData) {
        tlTitle.text = post.data?.title
        let date = convertDate(post.data?.created)
        tlAuthor.text = "\(post.data?.authorName ?? "") \(date)"
        ivImage.image = loadImage(post.data?.thumbnailURL)
        tlComments.text = "\(post.data?.commentsCount ?? 0) comments"
    }
    
    private func convertDate(_ date: Int?) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(date ?? 0))
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let relativeDate = formatter.localizedString(for: date, relativeTo: Date())
        
        return relativeDate
    }
    
    private func loadImage(_ url: URL?) -> UIImage? {
        guard let url = url, let data = try? Data(contentsOf: url) else  { return nil }
        return UIImage(data: data)
    }
    
}
