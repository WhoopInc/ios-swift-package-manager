# ios-swift-package-manager

A Swift package that wraps prebuilt third-party XCFrameworks so the WHOOP iOS app can link them as binaries instead of compiling them from source.

## Why this exists

Some vendors ship their SDK as a single zip containing many XCFrameworks (Stripe's `Stripe.xcframework.zip` holds 15). SwiftPM's `binaryTarget(url:)` requires exactly one XCFramework per archive, so that zip can't be referenced directly: SwiftPM extracts all 15 and picks an arbitrary one for every target. Binary targets also can't declare dependencies on each other, so the dependency closure has to be spelled out in the product definitions.

This repo solves both problems in one place:

- The XCFrameworks the app actually links are committed here, one zip per module, and exposed as `binaryTarget(path:)`.
- Products list every framework a consumer needs at link time, so a dependency on `StripePaymentSheet` brings along `StripeCore`, `StripeUICore`, `StripePayments`, `StripePaymentsUI`, `StripeApplePay`, and `Stripe3DS2`.
- The repo is public, so Xcode and CI resolve it without credentials, the same way they resolve `WhoopDI`.
- Vendor binaries stay out of the app repo's git history. Bumping a vendor replaces the zips here; consumers track `main`.

## Layout

```
Package.swift
Frameworks/
  Stripe/
    StripeCore.xcframework.zip
    StripeUICore.xcframework.zip
    Stripe3DS2.xcframework.zip
    StripeApplePay.xcframework.zip
    StripePayments.xcframework.zip
    StripePaymentsUI.xcframework.zip
    StripePaymentSheet.xcframework.zip
    CHECKSUMS.txt
```

Each `.xcframework.zip` contains exactly one `.xcframework` at its root, extracted unchanged from the vendor's release. `CHECKSUMS.txt` records the `swift package compute-checksum` value of each zip plus the SHA-256 of the upstream archive.

## Consuming from the app

```swift
dependencies: [
    .package(url: "https://github.com/WhoopInc/ios-swift-package-manager", branch: "main"),
],
targets: [
    .target(
        name: "WhoopPayments",
        dependencies: [
            .product(name: "StripePaymentSheet", package: "ios-swift-package-manager"),
        ]
    ),
]
```

Source files keep importing the vendor modules by their normal names (`import StripePayments`). Every target that imports a vendor module must declare the product dependency; with source packages SwiftPM tolerated undeclared transitive imports, with binaries it does not.
