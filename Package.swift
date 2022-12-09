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
            name: "Sentry",
            targets: ["Sentry"])
    ],
    targets: [
        .binaryTarget(
            name: "Intercom",
            url: "https://github.com/intercom/intercom-ios/releases/download/12.2.1/Intercom.xcframework.zip",
            checksum: "705469f671e803e74a30e51ae00be5eade2377bac3f789cacb684cb594d0f6a6"
        ),
        .binaryTarget(
            name: "Sentry",
            url: "https://github.com/getsentry/sentry-cocoa/releases/download/7.31.3/Sentry.xcframework.zip",
            checksum: "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
        )
    ]
)
