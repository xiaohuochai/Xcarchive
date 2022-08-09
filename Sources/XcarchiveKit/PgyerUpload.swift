//
//  Upload.swift
//  XcarchiveKit
//
//  Created by wangteng on 2022/8/5.
//

import Foundation
import Alamofire
import PathKit
import Rainbow

public class PgyerUpload {
    
    public let key: String
    
    public let uploadURL = URL(string: "https://www.pgyer.com/apiv2/app/upload")!
    
    public var response: [String: Any] = [:]
    
    public init(key: String) {
        self.key = key
    }
    
    public func shortURL() -> String {
        var shortURL = "https://www.pgyer.com/"
        if let suffix = (response["buildShortcutUrl"] as? String) {
            shortURL += suffix
        }
        return shortURL
    }
    
    public func desc() -> String {
        let buildVersion = (response["buildVersion"] as? String) ?? ""
        let buildBuildVersion = (response["buildBuildVersion"] as? String) ?? ""
        return "版本："+buildVersion+" (build "+buildBuildVersion+")"
    }
    
    public func title() -> String {
        return (response["buildName"] as? String) ?? ""
    }
    
    @discardableResult
    public func upload(ipaPath: String) -> [String: Any] {
        
        self.response.removeAll()
        
        var response: [String: Any] = [:]
        
        guard !key.isEmpty else {
            print("the KeyConfiguation.pgykey is invalid".red)
            return response
        }
        
        guard Path(ipaPath).exists else {
            print("ipa not found at path "+ipaPath.red)
            return response
        }
        
        var group = true
        
        let upload = AF.upload(multipartFormData: { formdata in
            formdata.append(self.key.data(using: .utf8)!, withName: "_api_key")
            formdata.append(URL(fileURLWithPath: ipaPath), withName: "file")
        },to: uploadURL)
        
        let queue = DispatchQueue.init(label: "uplaod pgy")
        upload.uploadProgress(queue: queue) { progress in
            let p = Int((Double(progress.completedUnitCount) / Double(progress.totalUnitCount)) * 100)
            print("upload:\(p)%".lightCyan)
        }
        upload.responseData(queue: queue) { dataResponse in
            switch dataResponse.result {
            case .success(let data):
                if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any],
                    let jsonData = json["data"] as? [String : Any] {
                    let suffix = (jsonData["buildShortcutUrl"] as? String) ?? ""
                    print("upload success".lightGreen, "https://www.pgyer.com/"+suffix)
                    response = jsonData
                    group = false
                } else {
                    print("upload success".lightGreen)
                    group = false
                }
            case .failure(let error):
                print("upload failure: \(error)".red)
                group = false
            }
        }
        
        while group {
            Thread.sleep(forTimeInterval: 1)
        }
        self.response = response
        return response
    }
}

