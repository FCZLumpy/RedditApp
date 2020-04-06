//
//  ViewControllerModels.swift
//  RedditTest
//
//  Created by Oleksandr Balytskyi on 27.03.2020.
//  Copyright © 2020 Oleksandr Balytskyi. All rights reserved.
//

// Single Post
struct SinglePost {
    let authorName: String
    let title: String
    let thumbnailURL: String
    let created: Int
    let commentsCount: Int
    let name: String
    let imageURL: String
}

extension SinglePost: Decodable {
    enum SinglePostKeys: String, CodingKey {
        case authorName = "author"
        case title
        case thumbnailURL = "thumbnail"
        case created
        case commentsCount = "num_comments"
        case name
        case imageURL = "url"
        case preview
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SinglePostKeys.self)
        authorName = try container.decode(String.self, forKey: .authorName)
        title = try container.decode(String.self, forKey: .title)
        thumbnailURL = try container.decode(String.self, forKey: .thumbnailURL)
        created = try container.decode(Int.self, forKey: .created)
        commentsCount = try container.decode(Int.self, forKey: .commentsCount)
        name = try container.decode(String.self, forKey: .name)
        imageURL = try container.decode(String.self, forKey: .thumbnailURL)
        //Here should be imageURL from preview, but I dont know why I receive 403 in app and in Safary
      /*  let image = try container.decode(Preview.self, forKey: .preview)
        imageURL = image.images.first?.source.url ?? "" */
    }
}

// Decode preview
struct Preview {
    let images : [Source]
}

extension Preview: Decodable {
    enum PreviewKeys: String, CodingKey {
        case images
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PreviewKeys.self)
        images = try container.decode([Source].self, forKey: .images)
    }
}

// Decode preview
struct Source {
    let source : PreviewUrl
}

extension Source: Decodable {
    enum SourceKeys: String, CodingKey {
        case source
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SourceKeys.self)
        source = try container.decode(PreviewUrl.self, forKey: .source)
    }
}

// Decode url
struct PreviewUrl {
    let url : String
}

extension PreviewUrl: Decodable {
    enum PreviewUrlKeys: String, CodingKey {
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PreviewUrlKeys.self)
        url = try container.decode(String.self, forKey: .url)
    }
}

// Single Post from Data
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

// Posts List
struct Children {
    let children: [PostData]
}

extension Children: Decodable {
    enum ChildrenKeys: String, CodingKey {
        case children
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ChildrenKeys.self)
        children = try container.decode([PostData].self, forKey: .children)
    }
}

// All data
struct TopData {
    let topData: Children
}

extension TopData: Decodable {
    enum TopDataKeys: String, CodingKey {
        case topData = "data"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TopDataKeys.self)
        topData = try container.decode(Children.self, forKey: .topData)
    }
}
