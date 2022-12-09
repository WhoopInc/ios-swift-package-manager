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
            targets: ["Carthage"])
    ],
    targets: [
        .binaryTarget(
            name: "Intercom",
            url: "https://github.com/intercom/intercom-ios/releases/download/12.2.1/Intercom.xcframework.zip",
            checksum: "705469f671e803e74a30e51ae00be5eade2377bac3f789cacb684cb594d0f6a6"
        ),
        // The target is `Carthage/Build/Sentry.xcframework`, so this is really sentry
        .binaryTarget(
            name: "Carthage",
            url: "https://github.com/getsentry/sentry-cocoa/releases/download/7.31.3/Sentry.xcframework.zip",
            checksum: "73bbf75e36b29336f3c6a78eb6e904b344327f435cc7538b1e72365536a73e51"
        )
    ]
)
