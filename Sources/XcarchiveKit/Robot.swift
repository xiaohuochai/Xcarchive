//
//  Robot.swift
//  XcarchiveKit
//
//  Created by wangteng on 2022/8/8.
//

import Foundation
import Alamofire

/// https://developer.work.weixin.qq.com/document/path/90854
public class Robot {
    
    public static let shared = Robot()
    
    public var resource = ""
    
    public func sendMessage(message: String) {
        let msgJson: [String: Any] = ["msgtype":"text",
                                      "text": ["content": message]]
        guard let msgData = try? JSONSerialization.data(withJSONObject: msgJson, options: JSONSerialization.WritingOptions.prettyPrinted) else {
            return
        }
        _send(msgData)
    }
    
    public func sendArticle(title: String,
                            description: String,
                            url: String = "https://www.pgyer.com/sh6F") {
        let article = ["title": title,
                       "description": description,
                       "picurl": "https://img95.699pic.com/xsj/1n/78/48.jpg!/fh/300",
                       "url":url]
        let msgJson: [String: Any] = ["msgtype":"news",
                                      "news": ["articles": [article]]]
        guard let msgData = try? JSONSerialization.data(withJSONObject: msgJson, options: .fragmentsAllowed) else {
            return
        }
        _send(msgData)
    }
    
    private func _send(_ data: Data?) {
        guard let resourceURL = URL(string: resource) else { fatalError() }
        
        var group = true
        var request = URLRequest(url: resourceURL, cachePolicy:.reloadIgnoringCacheData, timeoutInterval: 10)
        request.method = .post
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        URLSession.shared.dataTask(with: request, completionHandler: { (_, _, _) in
            group = false
        }).resume()
        while group {
            Thread.sleep(forTimeInterval: 1)
        }
    }
}
