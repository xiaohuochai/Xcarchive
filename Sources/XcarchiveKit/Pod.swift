//
//  Pod.swift
//  XcarchiveKit
//
//  Created by wangteng on 2022/8/5.
//

import Foundation

public struct Pod {
    
    public let path: String
    
    @discardableResult
    public func install() -> Set<String> {
        
        var environment = [String: String]()
        
        environment["LANG"] = "en_US.UTF-8"
        environment["PATH"] = "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin:/Users/gree/.rvm/bin"
        environment["CP_HOME_DIR"] = NSHomeDirectory().appending("/.cocoapods")
        
        let p = Process.make(launchPath: "/usr/local/bin/pod", arguments: ["install"])
        p.environment = environment
        p.currentDirectoryPath = path
        return p.execute()
    }
}
