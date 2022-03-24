// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "Intercom",
    products: [
        .library(
            name: "Intercom",
            targets: ["Intercom"]),
//         .library(
//             name: "CorePlot",
//             targets: ["CorePlot"]),
    ],
    targets: [
        .binaryTarget(
            name: "Intercom",
            url: "https://github.com/intercom/intercom-ios/releases/download/11.2.0/Intercom.xcframework.zip",
            checksum: "a859e7534e1605492be6d1edb417fb8025ae2022e475d41fb5a7f70bd85560f7"
        ),
//         .binaryTarget(
//             name: "CorePlot",
//             url: "https://github.com/core-plot/core-plot/releases/download/release_2.2/CorePlot_2.2.zip",
//             checksum: "93883245b0fa26266a14176bc22a1c63a507bd597da39164ba4780600031feae"
//         ),
    ]
)