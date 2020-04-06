//
//  ViewControllerConsts.swift
//  RedditTest
//
//  Created by Oleksandr Balytskyi on 27.03.2020.
//  Copyright © 2020 Oleksandr Balytskyi. All rights reserved.
//

import Foundation

struct ViewControllerConsts {
    // values
    static let redditURL = "https://www.reddit.com/top.json"
    static let cell = "ViewControllerCell"
    static let singlePost = "SinglePostEntity"
    static let limit = "limit"
    static let currentCount = "after"
    static let pageSize = "25"
    
    // CoreData names
    static let authorName = "authorName"
    static let commentsCount = "commentsCount"
    static let created = "created"
    static let title = "title"
    static let thumbnailURL = "thumbnailURL"
    static let name = "name"
    static let imageURL = "imageURL"
    
    //text
    static let warning = "Warning"
    static let dataIsEmpty = "Data is empty or you have connection error"
    static let retry = "Retry"
    static let cancel = "Cancel"
    static let imageSaved = "Image was saved to photo library"
    static let clickTocontinue = "Click ok to continue"
    static let ok = "OK"
}
