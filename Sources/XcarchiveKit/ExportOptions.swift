//
//  ExportOptions.swift
//  XcarchiveKit
//
//  Created by wangteng on 2022/8/5.
//

import Foundation
import XcodeProj
import PathKit
import Rainbow
import Logger

public struct ExportOptions {
    
    public enum Method: String {
        case app_store = "app-store"
        case ad_hoc = "ad-hoc"
        case enterprise
        case development
        case mac_application = "mac-application"
        case package
    }
    
    public var xcodeprojPath = ""
    public var method: Method = .ad_hoc
    public var configurationName = ""
    public var outputPath = ""
    
    public init(xcodeprojPath: String,
                method: Method = .ad_hoc,
                configurationName: String = "Release",
                outputPath: String) {
        self.xcodeprojPath = xcodeprojPath
        self.method = method
        self.configurationName = configurationName
        self.outputPath = outputPath
    }
    
    public func write() {
        Logger.info("generate exportOptions.plist file: \(outputPath)")
        let exportOptionData = exportOptionsData()
        if #available(macOS 10.13, *) {
            try? (exportOptionData as NSDictionary).write(to: URL(fileURLWithPath: outputPath))
        } else {
            // Fallback on xearlier versions
        }
    }
    
    public func exportOptionsData()-> [String: Any] {
       
        guard let xcodeproj = try? XcodeProj(path: Path(xcodeprojPath)) else {
            return [:]
        }
        
        /// https://www.yuukizoom.top/2021/04/13/%E5%85%B3%E4%BA%8EexportOptions.plist%E7%9A%84%E8%AF%B4%E6%98%8E/
        var provisioningProfiles: [String: String] = [:]
        var exportOptions: [String: Any] = ["method": method.rawValue,
                                            "stripSwiftSymbols": true,
                                            "thinning": "<none>"]

        for conf in xcodeproj.pbxproj.buildConfigurations where conf.name == configurationName {
            
            ///  该参数告诉Xcode是否需要通过bitcode重新编译，需要与app中的Enable Bitcode配置一致。
            if let compileBitcode = conf.buildSettings["ENABLE_BITCODE"] as? String {
                exportOptions["compileBitcode"] = (compileBitcode as NSString).boolValue
            }
            
            /// 该参数在手动配置签名下生效。指定包内所有可执行文件的描述文件。
            /// 其中key为可执行文件对应的bundle identifier，value为描述文件的文件名或UUID
            if let bundleIdentifier = conf.buildSettings["PRODUCT_BUNDLE_IDENTIFIER"] as? String, !bundleIdentifier.isEmpty,
               let profile = conf.buildSettings["PROVISIONING_PROFILE_SPECIFIER"] as? String, !profile.isEmpty {
                provisioningProfiles[bundleIdentifier] = profile
                exportOptions["provisioningProfiles"] = provisioningProfiles
                
                /// 该参数在手动配置签名下生效。可以配置为证书名称、SHA-1 Hash或者自动选择。
                /// 其中自动选择允许Xcode自动选择最新可以使用的证书，
                /// 可选值为：”iOS Developer”、”iOS Distribution”、”Developer ID Application”、”Apple Distribution”、
                /// ”Mac Developer”和”Apple Development”。默认值和导出类型相关
                if let signingCertificate = conf.buildSettings["CODE_SIGN_IDENTITY[sdk=iphoneos*]"] as? String, !signingCertificate.isEmpty {
                    exportOptions["signingCertificate"] = signingCertificate
                }
            }
            
            if let signingStyle = conf.buildSettings["CODE_SIGN_STYLE"] as? String, !signingStyle.isEmpty {
                exportOptions["signingStyle"] = signingStyle.lowercased()
            }
            
            /// 该参数表明导出包使用的开发者ID
            if let teamID = conf.buildSettings["DEVELOPMENT_TEAM"] as? String, !teamID.isEmpty {
                exportOptions["teamID"] = teamID
            }
        }
        return exportOptions
    }
}
