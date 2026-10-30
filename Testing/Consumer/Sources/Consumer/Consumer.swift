// Compile check for CI: this package consumes every product the way the iOS app does,
// so a corrupt, mismatched, or incomplete framework zip fails the build here before it ships.
import StripeApplePay
import StripeCore
import StripePayments
import StripePaymentSheet

public enum Consumer {
    public static let paymentSheetType = PaymentSheet.self
}
