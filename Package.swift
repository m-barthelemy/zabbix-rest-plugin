// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "zabbixRestPlugin",
    dependencies: [
        .Package(url: "https://github.com/m-barthelemy/zabbix-swift", majorVersion: 0, minor: 0),
        .Package(url: "https://github.com/IBM-Swift/SwiftyJSON.git", majorVersion: 16, minor: 0),
        //.Package(url: "https://github.com/yahoojapan/SwiftyXMLParser.git", majorVersion: 3, minor: 0),
        .Package(url: "https://github.com/tid-kijyun/Kanna.git", majorVersion: 2),
        .Package(url: "https://github.com/Zewo/POSIX.git", majorVersion: 0, minor: 15),
    ]
)

let libZbxRest = Product(name: "zabbixRestPlugin", type: .Library(.Dynamic), modules: "zabbixRestPlugin")
products.append(libZbxRest)
