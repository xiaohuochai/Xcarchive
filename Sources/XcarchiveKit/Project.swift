//
//  File.swift
//  
//
//  Created by wangteng on 2022/8/5.
//

import Foundation
import Rainbow
import KakaJSON
import Logger

public struct Project {
    
    public let path: String
    
    public var name = ""
    
    public var scheme = ""
    
    public var workspace: String {
        path+"/"+self.name+".xcworkspace"
    }
    
    public var archivePath: String {
        outputPath+"/"+self.name+".xcarchive"
    }
    
    public var exportPath: String {
        outputPath+"/"+"ipa"
    }
  
    public var ipaPath: String {
        exportPath+"/"+name+".ipa"
    }
    
    public var configuration = "Release"
    
    public var outputPath = ""
    
    public var exportOptionsPlist = ""
    
    public var xcodeprojPath: String {
        path+"/"+self.name+".xcodeproj"
    }
    
    public static let fileManager = FileManager.default
    
    public init(path: String, outputPath: String) {
        self.path = path
        self.outputPath = outputPath
        
        guard let allFileNames = try? Project.fileManager.contentsOfDirectory(atPath: path),
        !allFileNames.isEmpty else {
            Logger.error("not find *.xcodeproj")
            exit(EX_USAGE)
        }
        let name = allFileNames.first(where: { $0.hasSuffix(".xcodeproj") })?.components(separatedBy: ".").first ?? ""
        
        guard !name.isEmpty else {
            Logger.error("not find *.xcodeproj")
            exit(EX_USAGE)
        }
                
        self.name = name
                
        let xcschemesPath = path+"/"+self.name+".xcodeproj/xcshareddata/xcschemes"
        guard let xcschemes = try? Project.fileManager.contentsOfDirectory(atPath: xcschemesPath) else { return }
        scheme = xcschemes.first?.components(separatedBy: ".").first ?? ""
    }
}

public extension Project {
    
    func needPodInstall() -> Bool {
        guard let allFileNames = try? Project.fileManager.contentsOfDirectory(atPath: path),
        !allFileNames.isEmpty else {
            return false
        }
        return allFileNames.contains("Podfile")
    }
    
    func podInstall() {
        guard needPodInstall() else { return }
        Logger.info("pod install ...")
        Pod(path: path).install()
    }
}

public extension Project {
    
    @discardableResult
    func clean() -> Set<String> {
        let arguments = ["clean",
                         "-workspace",workspace,
                         "-scheme", scheme,
                         "-configuration",configuration,
                         "-destination", "generic/platform=iOS",
                        ]
        Logger.info("clean workspace ...")
        return Process.make(arguments: arguments).execute()
    }
    
    @discardableResult
    func archive()->Set<String>{
        let arguments = ["archive",
                         "-workspace",workspace,
                         "-scheme", scheme,
                         "-configuration",configuration,
                         "-destination", "generic/platform=iOS",
                         "-archivePath", archivePath
                        ]
        Logger.info("archive ...")
        return Process.make(arguments: arguments).execute()
    }
    
    @discardableResult
    func export()->Set<String> {
        let arguments = ["-exportArchive",
                         "-archivePath",archivePath,
                         "-exportPath",exportPath,
                         "-exportOptionsPlist",exportOptionsPlist
                        ]
        Logger.info("export ipa ...")
        return Process.make(arguments: arguments).execute()
    }
}
