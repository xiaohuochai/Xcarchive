import CommandLineKit
import Rainbow
import XcarchiveKit
import Foundation
import PathKit
import Commands
import Logger

let appVersion = "0.1.0"

let cli = CommandLineKit.CommandLine()
cli.formatOutput = { s, type in
    var string: String
    switch(type) {
    case .error: string = s.red.bold
    case .optionFlag: string = s.green.underline
    default: string = s
    }
    return cli.defaultFormat(s: string, type: type)
}

let projectPathOption = StringOption(
    shortFlag: "p", longFlag: "project", required: true,
    helpMessage: "Root path of your Xcode project")
cli.addOption(projectPathOption)

let outputPathOption = StringOption(
    shortFlag: "o", longFlag: "output",
    helpMessage: "Package path. Default is current project path /xcarchive")
cli.addOption(outputPathOption)

let configurationOption = StringOption(
    shortFlag: "c", longFlag: "configuration",
    helpMessage: "The name of pbxproj buildConfigurations. Default is Release")
cli.addOption(configurationOption)

let exportOption = StringOption(
    shortFlag: "e", longFlag: "exportOption", required: true,
    helpMessage: "Root path of your exportOption")
cli.addOption(exportOption)

let versionOption = BoolOption(longFlag: "version", helpMessage: "Print version.")
cli.addOption(versionOption)

let helpOption = BoolOption(shortFlag: "h", longFlag: "help",
                      helpMessage: "Print this help message.")
cli.addOption(helpOption)

do {
    try cli.parse()
} catch {
    cli.printUsage(error)
    exit(EX_USAGE)
}

if helpOption.value {
    cli.printUsage()
    exit(EX_OK)
}

if versionOption.value {
    print(appVersion)
    exit(EX_OK);
}

let projectPath = projectPathOption.value ?? ""
if projectPath.isEmpty || !Path(projectPath).exists {
    print("-p \(projectPath) is not invalid".red)
    exit(EX_USAGE)
}

/// 打包输出路径
let outputPath = outputPathOption.value ?? (projectPath+"/xcarchive")

/// 打包配置名称（对应Xcode中的`Configuration`）
let configuration = configurationOption.value ?? "Release"


let path = Path(outputPath)
if path.exists {
    try? path.delete()
}
try? path.mkdir()

let exportOptionPath = exportOption.value ?? ""
if exportOptionPath.isEmpty || !Path(exportOptionPath).exists {
    print("-p \(exportOptionPath) is not invalid".red)
    exit(EX_USAGE)
}

var project = Project(path: projectPath, outputPath: outputPath)
project.configuration = configuration

project.clean()

project.podInstall()

project.archive()

project.exportOptionsPlist = exportOptionPath
project.export()

uploadIpa()

try? path.delete()

func uploadIpa() {
    
    struct KeyConfiguation {
        /// 企业微信机器人webhook地追
        static let robotURL = ""
        /// 上传蒲公英key
        static let pgyKey = ""
    }
    
    let robot = Robot.shared
    robot.resource = KeyConfiguation.robotURL

    if !KeyConfiguation.pgyKey.isEmpty {
        let pgyUpload =  PgyerUpload(key: KeyConfiguation.pgyKey)
        pgyUpload.upload(ipaPath: project.ipaPath)
        
        if !KeyConfiguation.robotURL.isEmpty {
            robot.sendArticle(title: pgyUpload.title(),
                                     description: pgyUpload.desc(),
                                     url: pgyUpload.shortURL())
        }
    }
}

/// 导出ipa所需要的配置文件
//let exportOptionsOutput = outputPath+"/exportOptions.plist"
//ExportOptions(xcodeprojPath: project.xcodeprojPath,
//              method: .ad_hoc,
//              configurationName: configuration,
//              outputPath: exportOptionsOutput)
//    .write()
