//
//  ViewControllerModels.swift
//  RedditTest
//
//  Created by Oleksandr Balytskyi on 27.03.2020.
//  Copyright © 2020 Oleksandr Balytskyi. All rights reserved.
//

import Foundation

struct SinglePost {
    let authorName: String
    let title: String
    let thumbnailURL: String
    let created: Int
    let commentsCount: Int
    let name: String
}

extension SinglePost: Decodable {
    enum SinglePostKeys: String, CodingKey {
        case authorName = "author"
        case title
        case thumbnailURL = "thumbnail"
        case created
        case commentsCount = "num_comments"
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SinglePostKeys.self)
        authorName = try container.decode(String.self, forKey: .authorName)
        title = try container.decode(String.self, forKey: .title)
        thumbnailURL = try container.decode(String.self, forKey: .thumbnailURL)
        created = try container.decode(Int.self, forKey: .created)
        commentsCount = try container.decode(Int.self, forKey: .commentsCount)
        name = try container.decode(String.self, forKey: .name)
    }
}

struct PostData {
    let data: SinglePost
}

extension PostData: Decodable {
    enum PostDataKeys: String, CodingKey {
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PostDataKeys.self)
        data = try container.decode(SinglePost.self, forKey: .data)
    }
}

struct Children {
    let children: [PostData]
    let dist: Int
}

extension Children: Decodable {
    enum ChildrenKeys: String, CodingKey {
        case children
        case dist
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ChildrenKeys.self)
        children = try container.decode([PostData].self, forKey: .children)
        dist = try container.decode(Int.self, forKey: .dist)
    }
}

struct TopData {
    let topData: Children
    let kind: String
}

extension TopData: Decodable {
    enum TopDataKeys: String, CodingKey {
        case topData = "data"
        case kind
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TopDataKeys.self)
        topData = try container.decode(Children.self, forKey: .topData)
        kind = try container.decode(String.self, forKey: .kind)
    }
}
