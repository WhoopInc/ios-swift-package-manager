# ios-swift-package-manager

Public Swift package that wraps prebuilt third-party XCFrameworks for the WHOOP iOS app. Every file here ships in the app, so changes go through a PR reviewed by a code owner.

## Rules

- SwiftPM requires exactly one XCFramework per archive. Never point a `binaryTarget` at a vendor archive that bundles several frameworks.
- Binaries are extracted from the vendor's official release unchanged. Never rebuild, strip, or edit a framework.
- Binary targets can't declare dependencies, so each product lists every framework its module loads at runtime.
- Create zips with `ditto -c -k --keepParent <Name>.xcframework <Name>.xcframework.zip` so the framework sits at the archive root.

## Layout

- `Package.swift`: one `binaryTarget(name:path:)` per zip, one product per module the app imports.
- `Frameworks/<Vendor>/`: the zips, plus `VERSIONS` (expected `CFBundleShortVersionString` per framework) and `CHECKSUMS.txt` (`swift package compute-checksum` per zip, the upstream archive URL, and its SHA-256).
- `scripts/verify_frameworks.sh`: checks every zip against `VERSIONS`, `CHECKSUMS.txt`, `Package.swift`, and the upstream archive. Set `SKIP_UPSTREAM=true` to skip the download.
- `Testing/Consumer`: a package that imports every product. CI builds it for iOS Simulator to prove the frameworks resolve and compile.
- `.circleci/config.yml`: runs the script, then builds `Testing/Consumer`.

## Updating a vendor

1. Download the new release archive from the vendor's GitHub release and record its SHA-256 (`shasum -a 256`).
2. Extract it with `ditto -x -k` and copy out only the frameworks already in `Frameworks/<Vendor>/`.
3. Check each framework's runtime dependencies with `otool -L <framework binary> | grep @rpath`. If a new one appears, add it as a zip, a `binaryTarget`, and an entry in every product that loads it.
4. Zip each framework individually and replace the old zips.
5. Update `VERSIONS` from each framework's `Info.plist`. Vendors can version sub-frameworks separately (Stripe3DS2 is `1.0` while the rest of Stripe is `26.x`).
6. Regenerate `CHECKSUMS.txt`: the upstream URL and SHA-256, then `swift package compute-checksum` for every zip.
7. Run `./scripts/verify_frameworks.sh` and open a PR.

## Adding a vendor

1. Confirm the vendor publishes XCFrameworks built for distribution (library evolution), and that its license allows redistribution.
2. Create `Frameworks/<Vendor>/` and follow steps 1–6 above for the frameworks the app imports plus their runtime dependencies.
3. Add a `binaryTarget` per zip and a product per imported module to `Package.swift`.
4. Import the new products in `Testing/Consumer` so CI compiles against them.
5. Run `./scripts/verify_frameworks.sh` and open a PR.

## Consuming in the iOS app

App packages depend on `.package(url: "https://github.com/WhoopInc/ios-swift-package-manager", branch: "main")` and use `.product(name: "<Module>", package: "ios-swift-package-manager")`. After a change merges here, re-resolve packages in the iOS repo so its `Package.resolved` picks up the new commit.
