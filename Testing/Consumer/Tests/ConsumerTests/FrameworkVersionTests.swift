import Foundation
import StripeCore
import StripePaymentSheet
import Testing

// The vendor versions this package is meant to ship. Bump these in the same PR that replaces the zips,
// so every version change is deliberate and reviewed.
private let expectedVersions = [
    "com.stripe.stripe-core": "26.1.0",
    "com.stripe.stripe-ui-core": "26.1.0",
    "com.stripe.stripe-3ds2": "1.0",
    "com.stripe.stripe-apple-pay": "26.1.0",
    "com.stripe.stripe-payments": "26.1.0",
    "com.stripe.stripe-payments-ui": "26.1.0",
    "com.stripe.stripe-payment-sheet": "26.1.0",
]

@Suite struct StripeFrameworkVersionTests {
    init() {
        _ = PaymentSheet.self
    }

    @Test func stripeSDKVersion() {
        #expect(STPAPIClient.STPSDKVersion == expectedVersions["com.stripe.stripe-core"])
    }

    @Test func stripeCore() throws {
        try expectVersion(of: "com.stripe.stripe-core")
    }

    @Test func stripeUICore() throws {
        try expectVersion(of: "com.stripe.stripe-ui-core")
    }

    @Test func stripe3DS2() throws {
        try expectVersion(of: "com.stripe.stripe-3ds2")
    }

    @Test func stripeApplePay() throws {
        try expectVersion(of: "com.stripe.stripe-apple-pay")
    }

    @Test func stripePayments() throws {
        try expectVersion(of: "com.stripe.stripe-payments")
    }

    @Test func stripePaymentsUI() throws {
        try expectVersion(of: "com.stripe.stripe-payments-ui")
    }

    @Test func stripePaymentSheet() throws {
        try expectVersion(of: "com.stripe.stripe-payment-sheet")
    }

    private func expectVersion(of bundleIdentifier: String) throws {
        let bundle = try #require(Bundle(identifier: bundleIdentifier), "\(bundleIdentifier) is not linked")
        let linkedVersion = bundle.infoDictionary?["CFBundleShortVersionString"] as? String
        #expect(linkedVersion == expectedVersions[bundleIdentifier])
    }
}
