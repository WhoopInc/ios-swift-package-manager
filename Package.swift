// swift-tools-version:6.2

import PackageDescription

let package = Package(
    name: "ios-swift-package-manager",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "StripeCore",
            targets: ["StripeCore"]),
        .library(
            name: "StripeApplePay",
            targets: ["StripeApplePay", "StripeCore"]),
        .library(
            name: "StripePayments",
            targets: ["StripePayments", "StripeCore", "Stripe3DS2"]),
        .library(
            name: "StripePaymentSheet",
            targets: ["StripePaymentSheet", "StripePaymentsUI", "StripePayments", "StripeApplePay", "StripeUICore", "StripeCore", "Stripe3DS2"]),
    ],
    targets: [
        .binaryTarget(name: "StripeCore", path: "Frameworks/Stripe/StripeCore.xcframework.zip"),
        .binaryTarget(name: "StripeUICore", path: "Frameworks/Stripe/StripeUICore.xcframework.zip"),
        .binaryTarget(name: "Stripe3DS2", path: "Frameworks/Stripe/Stripe3DS2.xcframework.zip"),
        .binaryTarget(name: "StripeApplePay", path: "Frameworks/Stripe/StripeApplePay.xcframework.zip"),
        .binaryTarget(name: "StripePayments", path: "Frameworks/Stripe/StripePayments.xcframework.zip"),
        .binaryTarget(name: "StripePaymentsUI", path: "Frameworks/Stripe/StripePaymentsUI.xcframework.zip"),
        .binaryTarget(name: "StripePaymentSheet", path: "Frameworks/Stripe/StripePaymentSheet.xcframework.zip"),
    ]
)
