// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "Intercom",
    products: [
        .library(
            name: "Intercom",
            targets: ["Intercom"]),
        .library(
            name: "IterableSDK",
            targets: ["IterableSDK"]),
    ],
    targets: [
        .binaryTarget(
            name: "Intercom",
            url: "https://github.com/intercom/intercom-ios/releases/download/11.2.0/Intercom.xcframework.zip",
            checksum: "a859e7534e1605492be6d1edb417fb8025ae2022e475d41fb5a7f70bd85560f7"
        ),
        .binaryTarget(
            name: "IterableSDK",
            url: "https://github.com/Iterable/swift-sdk/releases/download/6.3.2/IterableSDK.xcframework.zip",
            checksum: "d02f37b40783569612d5e82f8da94acfca1e81d97a176dca866a86b8886560b3"
        ),
    ]
)