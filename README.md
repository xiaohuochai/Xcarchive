<p align="center">
<img src="https://swift.org/assets/images/swift.svg" alt="Xcarchive" title="Xcarchive" height="70"/>
</p>

<p align="center">
<a href="https://swift.org/package-manager/"><img src="https://img.shields.io/badge/swift-5.0+-brightgreen.svg"/></a>
<a href="https://swift.org/package-manager/"><img src="https://img.shields.io/badge/SPM-ready-orange.svg"></a>
<a href="https://raw.githubusercontent.com/onevcat/Kingfisher/master/LICENSE"><img src="https://img.shields.io/cocoapods/l/Kingfisher.svg?style=flat"></a>
<a href="https://swift.org/package-manager/"><img src="https://img.shields.io/badge/platform-macos%20|%20Linux-blue.svg"/></a>
</p>

## What

Xcarchive is a simple command-line util to package ios and upload pgy.

## How

### Install

```bash
> git clone https://github.com/wangteng/Xcarchive.git
> cd Xcarchive
> swift build -c release

# Then copy the executable to your PATH, such as `/usr/local/bin`
> sudo cp .build/release/Xcarchive /usr/local/bin/Xcarchive
```

Xcarchive should be compiled, tested and installed into the `/usr/local/bin`.

### Usage

Just navigate to your project folder, then:

```shell
> Xcarchive
```
蒲公英配置
```shell

  in Main.swift
  
  struct KeyConfiguation {
    /// 企业微信机器人webhook地追
    static let robotURL = ""
    /// 上传蒲公英key
    static let pgyKey = ""
}
```

Xcarchive supports some arguments. You can find it by:

```shell
> Xcarchive --help

    Usage: ./Xcarchive [options]
    -p, --project:
        Root path of your Xcode project
    -o, --output:
        Package path. Default is current project path /xcarchive
    -c, --configuration:
        The name of pbxproj buildConfigurations. Default is Release
    --version:
        Print version.
    -h, --help:
        Print this help message.
```

#### 参考

- [Swfift CLI](https://mp.weixin.qq.com/s/tX8LPjmGLEV9IT1_smMQBw)


