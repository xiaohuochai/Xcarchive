//
//  Git.swift
//  XcarchiveKit
//
//  Created by wangteng on 2022/8/10.
//

import Foundation

public struct Repository {
    
    public enum Command {
        
        /// Show the working tree status
        case status
        
        /// Download objects and refs from another repository
        case fetch(_ repository: String)
        
        /// Update remote refs along with associated objects
        case push
        
        /// Fetch from and integrate with another repository or a local branch
        case pull
        
        /// List, create, or delete branches
        case branch(_ args: [String])
        
        /// Record changes to the repository
        case commit(_ message: String)
        
        /// Switch branches or restore local working tree files
        case checkout(_ args: [String])
        
        /// Switch branches
        case `switch`(_ args: [String])
        
        var arguments: [String] {
            switch self {
            case .status:
                return ["status"]
            case .fetch(let repository):
                return ["fetch",repository]
            case .push:
                return ["push"]
            case .branch(let args):
                var arguments: [String] = ["branch"]
                arguments.append(contentsOf: args)
                return arguments
            case .commit(let message):
                return ["commit", "-m", message].filter{ !$0.isEmpty }
            case .checkout(let args):
                var arguments: [String] = ["checkout"]
                arguments.append(contentsOf: args)
                return arguments
            case .pull:
                return ["pull"]
            case .switch(let args):
                var arguments: [String] = ["switch"]
                arguments.append(contentsOf: args)
                return arguments
            }
        }
    }
    
    public let path: String
    
    public init(path: String) {
        self.path = path
    }
    
    @discardableResult
    public func run(_ command: Command) -> String {
        let task = Process()
        task.launchPath = "/usr/bin/git"
        task.arguments = command.arguments
        task.currentDirectoryURL = URL(fileURLWithPath: path)
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        task.waitUntilExit()
        return output
    }
}
