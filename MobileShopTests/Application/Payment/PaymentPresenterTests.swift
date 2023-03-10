//
//  PaymentPresenterTests.swift
//  MobileShopTests
//
//  Created by Srđan Stanić on 09/12/2020.
//

import XCTest
@testable import MobileShop

class PaymentPresenterTests: XCTestCase {
    private var paymentTracker: PaymentTracking!
    private var firebaseAnalyticsServiceStub: FirebaseAnalyticsServiceStub!
    private var facebookAnalyticsServiceStub: FacebookAnalyticsServiceStub!
    private var localizerStub: LocalizerStub!
    private var paymentSceneOutputsSpy: PaymentSceneOutputsSpy!
    private var paymentViewSpy: PaymentViewSpy!

    override func setUpWithError() throws {
        firebaseAnalyticsServiceStub = FirebaseAnalyticsServiceStub()
        facebookAnalyticsServiceStub = FacebookAnalyticsServiceStub()
        paymentTracker = PaymentTracker(
            firebaseAnalyticsService: firebaseAnalyticsServiceStub,
            facebookAnalyticsService: facebookAnalyticsServiceStub
        )
        localizerStub = LocalizerStub()
        paymentSceneOutputsSpy = PaymentSceneOutputsSpy()
        paymentViewSpy = PaymentViewSpy()
    }

    func testAmountShownOnLoad() {
        let amount: Double = 10
        let sut = buildSUT(forAmount: amount)
        sut.view = paymentViewSpy

        sut.onViewDidLoad()

        XCTAssertEqual(paymentViewSpy.recordedAmountTitles, [localized("PAYMENT_SCENE_AMOUNT_TITLE")])
        XCTAssertEqual(paymentViewSpy.recordedAmountsShown, [localized("PAYMENT_SCENE_PRICE_AMOUNT", "10.00")])
        XCTAssertEqual(paymentViewSpy.recordedChargeNotes, [localized("PAYMENT_SCENE_CHARGE_NOTE")])
        XCTAssertEqual(paymentViewSpy.recodedConfirmPurchaseButtonTitles, [localized("PAYMENT_SCENE_CONFIRM_PURCHASE_BUTTON_TITLE")])
    }

    func testDidConfirmPayment() {
        let sut = buildSUT(forAmount: 0)
        sut.view = paymentViewSpy

        sut.onPurchaseConfirmed()

        let expectedAlertContent = RecordedAlertContent(
            title: localized("PAYMENT_SUCCESS_ALERT_TITLE"),
            message: localized("PAYMENT_SUCCESS_ALERT_MESSAGE"),
            actionTitles: [localized("PAYMENT_SUCCESS_ALERT_BUTTON_TITLE")]
        )
        XCTAssertEqual(paymentViewSpy.recordedAlertContents, [expectedAlertContent])

        XCTAssertEqual(paymentViewSpy.recordedOnDismissHandlers.count, 1)
        paymentViewSpy.recordedOnDismissHandlers.first!?()

        XCTAssertEqual(paymentSceneOutputsSpy.onPurchaseCompletedCallCount, 1)
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

    private func buildSUT(forAmount amount: Double) -> PaymentPresenter {
        return PaymentPresenter(
            for: amount,
            dependencies: .init(
                tracker: paymentTracker,
                localizer: localizerStub
            ),
            outputs: paymentSceneOutputsSpy
        )
    }
}

final class PaymentSceneOutputsSpy: PaymentSceneOutputs {
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
