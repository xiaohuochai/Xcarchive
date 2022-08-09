//
//  Process.swift
//  XcarchiveKit
//
//  Created by wangteng on 2022/8/5.
//

import Foundation

public extension Process {
    
    static func make(launchPath: String = "/usr/bin/xcodebuild",
                     arguments: [String]) -> Process {
        let p = Process()
        p.launchPath = launchPath
        p.arguments = arguments
        return p
    }
    
    @discardableResult
    func execute() -> Set<String> {
        let pipe = Pipe()
        self.standardOutput = pipe
        
        let fileHandler = pipe.fileHandleForReading
        self.launch()
        
        let data = fileHandler.readDataToEndOfFile()
        if let string = String(data: data, encoding: .utf8) {
            return Set(string.components(separatedBy: "\n").dropLast())
        } else {
            return []
        }
    }
}

