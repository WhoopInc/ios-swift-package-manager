// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "Whoop External Swift Packages",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "ExternalPackages",
            targets: ["Intercom", "IterableSDK", "Kingfisher"])
    ],
    targets: [
        .binaryTarget(
            name: "Intercom",
            url: "https://github.com/intercom/intercom-ios/releases/download/12.2.1/Intercom.xcframework.zip",
            checksum: "705469f671e803e74a30e51ae00be5eade2377bac3f789cacb684cb594d0f6a6"
        ),
        .binaryTarget(
            name: "IterableSDK",
            url: "https://github.com/Iterable/swift-sdk/releases/download/6.3.2/IterableSDK.xcframework.zip",
            checksum: "d02f37b40783569612d5e82f8da94acfca1e81d97a176dca866a86b8886560b3"
        ),
        .binaryTarget(
            name: "Kingfisher",
            url: "https://github.com/onevcat/Kingfisher/releases/download/7.6.2/Kingfisher-7.6.2.zip",
            checksum: "76a47eb79a6fb3387276a786d3f949db1e98d493d9fb8fa0eb5d5cec5d57ccda"
        )
    ]
)
