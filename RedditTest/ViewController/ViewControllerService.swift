//
//  ViewControllerService.swift
//  RedditTest
//
//  Created by Oleksandr Balytskyi on 27.03.2020.
//  Copyright © 2020 Oleksandr Balytskyi. All rights reserved.
//

import Foundation

class ViewControllerService {
    func connect(callback: @escaping([PostData]) -> Void) {
        guard let url = URL(string: ViewControllerConsts.redditURL) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let topData = try decoder.decode(TopData.self, from: data)
                callback(topData.topData?.children ?? [])
            } catch {
                callback([])
                print("json error: \(error)")
            }
        }
        
        task.resume()
    }
    
    func reloadData(callback: (Bool) -> Void) {
        print("reload data")
        callback(true)
    }
}


