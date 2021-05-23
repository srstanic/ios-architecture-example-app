//
//  PaymentControllerTests.swift
//  MobileShopTests
//
//  Created by Srđan Stanić on 09/12/2020.
//

import XCTest
@testable import MobileShop

class PaymentControllerTests: XCTestCase {
    private var paymentTracker: PaymentTracking!
    private var firebaseAnalyticsServiceStub: FirebaseAnalyticsServiceStub!
    private var facebookAnalyticsServiceStub: FacebookAnalyticsServiceStub!
    private var localizerStub: LocalizerStub!
    private var paymentControllerDelegateSpy: PaymentControllerDelegateSpy!
    private var paymentViewSpy: PaymentViewSpy!

    override func setUpWithError() throws {
        firebaseAnalyticsServiceStub = FirebaseAnalyticsServiceStub()
        facebookAnalyticsServiceStub = FacebookAnalyticsServiceStub()
        paymentTracker = PaymentTracker(
            firebaseAnalyticsService: firebaseAnalyticsServiceStub,
            facebookAnalyticsService: facebookAnalyticsServiceStub
        )
        localizerStub = LocalizerStub()
        paymentControllerDelegateSpy = PaymentControllerDelegateSpy()
        paymentViewSpy = PaymentViewSpy()
    }

    func testAmountShownOnLoad() {
        let amount: Double = 10
        let sut = buildSUT(forAmount: amount)
        sut.view = paymentViewSpy

        sut.onViewDidLoad()

        XCTAssertEqual(paymentViewSpy.recordedAmountTitles, ["PAYMENT_SCENE_AMOUNT_TITLE"])
        XCTAssertEqual(paymentViewSpy.recordedAmountsShown, ["PRICE_AMOUNT,10.00"])
        XCTAssertEqual(paymentViewSpy.recordedChargeNotes, ["PAYMENT_SCENE_CHARGE_NOTE"])
        XCTAssertEqual(paymentViewSpy.recodedConfirmPurchaseButtonTitles, ["PAYMENT_SCENE_CONFIRM_PURCHASE_BUTTON_TITLE"])
    }

    func testDidConfirmPayment() {
        let sut = buildSUT(forAmount: 0)
        sut.view = paymentViewSpy

        sut.onPurchaseConfirmed()

        let expectedAlertContent = RecordedAlertContent(
            title: "PAYMENT_SUCCESS_ALERT_TITLE",
            message: "PAYMENT_SUCCESS_ALERT_MESSAGE",
            actionTitles: ["PAYMENT_SUCCESS_ALERT_BUTTON_TITLE"]
        )
        XCTAssertEqual(paymentViewSpy.recordedAlertContents, [expectedAlertContent])

        XCTAssertEqual(paymentViewSpy.recordedOnDismissHandlers.count, 1)
        paymentViewSpy.recordedOnDismissHandlers.first!?()

        XCTAssertEqual(paymentControllerDelegateSpy.onPurchaseCompletedCallCount, 1)
    }

    func testTrackingVisit() {
        let sut = buildSUT(forAmount: 0)

        sut.onViewDidAppear()

        XCTAssertEqual(firebaseAnalyticsServiceStub.recordedEvents, [.sceneVisitEvent("Payment")])
    }

    func testTrackingPurchaseConfirmationAndCompletion() {
        let amount: Double = 10
        let sut = buildSUT(forAmount: amount)

        sut.onPurchaseConfirmed()

        XCTAssertEqual(
            firebaseAnalyticsServiceStub.recordedEvents,
            [.userActionEvent("Confirm Purchase"), .purchaseEvent(amount)]
        )

        XCTAssertEqual(facebookAnalyticsServiceStub.recordedEvents, [.purchaseEvent(amount)])
    }

    private func buildSUT(forAmount amount: Double) -> PaymentController {
        return PaymentController(
            for: amount,
            dependencies: .init(
                tracker: paymentTracker,
                localizer: localizerStub
            ),
            delegate: paymentControllerDelegateSpy
        )
    }
}

final class PaymentControllerDelegateSpy: PaymentControllerDelegate {
    func onPurchaseCompleted() {
        onPurchaseCompletedCallCount += 1
    }
    var onPurchaseCompletedCallCount = 0
}

final class PaymentViewSpy: AlertingViewStub, PaymentView {
    func setLoadingIndicatorVisibility(isHidden: Bool) {
        recordedLoadingIndicatorVisibilities.append(isHidden)
    }
    var recordedLoadingIndicatorVisibilities: [Bool] = []

    func setAmountTitle(_ amountTitle: String) {
        recordedAmountTitles.append(amountTitle)
    }
    var recordedAmountTitles: [String] = []

    func setChargeNote(_ chargeNote: String) {
        recordedChargeNotes.append(chargeNote)
    }
    var recordedChargeNotes: [String] = []

    func setConfirmPurchaseButtonTitle(_ confirmPurchaseButtonTitle: String) {
        recodedConfirmPurchaseButtonTitles.append(confirmPurchaseButtonTitle)
    }
    var recodedConfirmPurchaseButtonTitles: [String] = []

    func showAmount(_ amount: String) {
        recordedAmountsShown.append(amount)
    }
    var recordedAmountsShown: [String] = []
}
