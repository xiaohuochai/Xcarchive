// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Xcarchive",
    platforms: [.macOS("10.13")],
    products: [
        .executable(name: "Xcarchive", targets: ["Xcarchive"]),
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Rainbow.git", from: "3.1.1"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.4.3"),
        .package(url: "https://github.com/IngmarStein/CommandLineKit", from: "2.3.0"),
        .package(url: "https://github.com/kylef/PathKit.git", from: "1.0.1"),
        .package(url: "https://github.com/tuist/XcodeProj.git", from: "8.8.0"),
        .package(url: "https://github.com/kakaopensource/KakaJSON", from: "1.1.2")
    ],
    targets: [
        .target(
            name: "Commands", dependencies: []),
        .target(
            name: "Logger", dependencies: ["Rainbow"]),
        .target(name: "XcarchiveKit", dependencies: ["PathKit","Commands","XcodeProj","KakaJSON", "Logger"]),
        .executableTarget(
            name: "Xcarchive",
            dependencies: ["Alamofire","Rainbow","CommandLineKit","XcarchiveKit"]),
        .testTarget(
            name: "XcarchiveTests",
            dependencies: ["Xcarchive"]),
    ],
    swiftLanguageVersions: [.v5]
)
