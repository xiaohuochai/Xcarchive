//
//  ConsoleLogger.swift
//  IPATool
//
//  Created by Majd Alfhaily on 22.05.21.
//

import Foundation
import Rainbow

public struct Logger {
    
    public enum Mode: String {
        case inLine = "\u{1B}[1A\u{1B}[K"
        case next = ""
    }
    
    public enum Level: String {
        
        case error
        case warning
        case info
        case debug
        
        var prefix: String {
            switch self {
            case .error:
                return "[Error]"
            case .warning:
                return "[Warning]"
            case .info:
                return "[Info]"
            case .debug:
                return "[Debug]"
            }
        }
    }

    public init() {}
    
    public static func info(_ message: String, mode: Mode = .next) {
        self.log(message, level: .info, mode: mode)
    }
    
    public static func debug(_ message: String, mode: Mode = .next) {
        self.log(message, level: .debug, mode: mode)
    }
    
    public static func error(_ message: String, mode: Mode = .next) {
        self.log(message, level: .error, mode: mode)
    }
    
    public static func warning(_ message: String, mode: Mode = .next) {
        self.log(message, level: .warning, mode: mode)
    }
    
    public static func log(_ message: String, level: Level, mode: Mode = .next) {
        
        switch level {
        case .error:
            print(mode.rawValue,level.prefix.red,message.red)
        case .warning:
            print(mode.rawValue,level.prefix.yellow,message.yellow)
        case .info:
            print(mode.rawValue,level.prefix.green,message.white)
        case .debug:
            print(mode.rawValue,level.prefix.cyan,message.cyan)
        }
    }
   
}
