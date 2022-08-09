<p align="center">
<img src="https://raw.githubusercontent.com/onevcat/FengNiao/assets/logo.png" alt="Xcarchive" title="Xcarchive" width="468"/>
</p>

<p align="center">
<a href="https://travis-ci.org/onevcat/FengNiao"><img src="https://img.shields.io/travis/onevcat/FengNiao/master.svg"></a>
<a href="https://swift.org/package-manager/"><img src="https://img.shields.io/badge/swift-5.0+-brightgreen.svg"/></a>
<a href="https://swift.org/package-manager/"><img src="https://img.shields.io/badge/SPM-ready-orange.svg"></a>
<a href="https://raw.githubusercontent.com/onevcat/Kingfisher/master/LICENSE"><img src="https://img.shields.io/cocoapods/l/Kingfisher.svg?style=flat"></a>
<a href="https://swift.org/package-manager/"><img src="https://img.shields.io/badge/platform-macos%20|%20Linux-blue.svg"/></a>
<a href="https://codecov.io/gh/onevcat/Hedwig"><img src="https://codecov.io/gh/onevcat/Hedwig/branch/master/graph/badge.svg"/></a>
</p>

## What

Xcarchive is a simple command-line util to package ios and upload pgy.

## How

### Install

```bash
> git clone https://github.com/wangteng/Xcarchive.git
> cd FengNiao
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

FengNiao supports some arguments. You can find it by:

```shell
> Xcarchive --help

  Usage: Xcarchive [options]
  -p, --project:
      Root path of your Xcode project. Default is current folder.
  -o, --output:
      Root path of product. Default is current projectPath/xcarchive
  -c, --configuration:
      The name of pbxproj buildConfigurations. Default is Release
```

#### 参考

- [Part 1](https://mp.weixin.qq.com/s/tX8LPjmGLEV9IT1_smMQBw)


