import CommandLineKit
import Rainbow
import XcarchiveKit
import Foundation
import PathKit
import Commands

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
    helpMessage: "Root path of your Xcode project. Default is current folder.")
cli.addOption(projectPathOption)

let outputPathOption = StringOption(
    shortFlag: "o", longFlag: "output",
    helpMessage: "Root path of product. Default is current projectPath/xcarchive")
cli.addOption(outputPathOption)

let configurationOption = StringOption(
    shortFlag: "c", longFlag: "configuration",
    helpMessage: "The name of pbxproj buildConfigurations. Default is Release")
cli.addOption(configurationOption)

do {
    try cli.parse()
} catch {
    cli.printUsage(error)
    exit(EX_USAGE)
}

let projectPath = projectPathOption.value ?? ""
if projectPath.isEmpty || !Path(projectPath).exists {
    print("-p \(projectPath) is not invalid".red)
    exit(EX_USAGE)
}

struct KeyConfiguation {
    /// 企业微信机器人webhook地追
    static let robotURL = "https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=91fa466c-2c8b-4ad3-9ca9-3429e14ca9fa"
    /// 上传蒲公英key
    static let pgyKey = "5628e20e85a8ee57e82b69d45830fef8"
}

/// 打包输出路径
let outputPath = outputPathOption.value ?? (projectPath+"/xcarchive")

/// 打包配置名称（对应Xcode中的`Configuration`）
let configuration = configurationOption.value ?? "Release"

/// 导出ipa所需要的配置文件
let exportOptionsOutput = outputPath+"/ExportOptions.plist"

let path = Path(outputPath)
if path.exists {
    try? path.delete()
}
try? path.mkdir()

let robot = Robot.shared
robot.resource = KeyConfiguation.robotURL

var project = Project(path: projectPath, outputPath: outputPath)
project.configuration = configuration

project.clean()

project.podInstall()

project.archive()

ExportOptions(xcodeprojPath: project.xcodeprojPath,
              method: .ad_hoc,
              configurationName: configuration,
              outputPath: exportOptionsOutput)
    .write()
project.exportOptionsPlist = exportOptionsOutput
project.export()

let pgyUpload =  PgyerUpload(key: KeyConfiguation.pgyKey)
pgyUpload.uploadPgyer(ipaPath: project.ipaPath)

robot.sendArticle(title: pgyUpload.title(),
                         description: pgyUpload.desc(),
                         url: pgyUpload.shortURL())

//try? path.delete()
