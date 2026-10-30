// swift-tools-version:6.2

import PackageDescription

let package = Package(
    name: "Consumer",
    platforms: [.iOS(.v18)],
    products: [
        .library(name: "Consumer", targets: ["Consumer"]),
    ],
    dependencies: [
        .package(name: "ios-swift-package-manager", path: "../.."),
    ],
    targets: [
        .target(
            name: "Consumer",
            dependencies: [
                .product(name: "StripeCore", package: "ios-swift-package-manager"),
                .product(name: "StripeApplePay", package: "ios-swift-package-manager"),
                .product(name: "StripePayments", package: "ios-swift-package-manager"),
                .product(name: "StripePaymentSheet", package: "ios-swift-package-manager"),
            ]
        ),
    ]
)
