//
//  PaymentSceneAnalyticsTests.swift
//  MobileShopTests
//
//  Created by Srđan Stanić on 13.03.2023.
//

import XCTest
import MobileShop

final class PaymentSceneAnalyticsTests: XCTestCase {
    private var paymentServiceSpy: PaymentServiceSpy!
    private var firebaseAnalyticsServiceStub: FirebaseAnalyticsServiceStub!
    private var facebookAnalyticsServiceStub: FacebookAnalyticsServiceStub!

    override func setUp() {
        paymentServiceSpy = PaymentServiceSpy()
        firebaseAnalyticsServiceStub = FirebaseAnalyticsServiceStub()
        facebookAnalyticsServiceStub = FacebookAnalyticsServiceStub()
    }

    func testDidVisitSceneEventTracked() {
        let amount: Double = 12.99
        let sut = buildSUT(forAmount: amount)

        sut.appearedOnScreen()

        XCTAssertTrue(firebaseAnalyticsServiceStub.containsRecordedEvent(.sceneVisitEvent("Payment")))
    }

    func testConfirmPaymentUserActionEventTracked() {
        let amount: Double = 12.99
        let sut = buildSUT(forAmount: amount)

        sut.appearedOnScreen()
        sut.onPurchaseConfirmed()

        XCTAssertTrue(firebaseAnalyticsServiceStub.containsRecordedEvent(.userActionEvent("Confirm Purchase")))
    }

    func testPurchaseEventTrackedWhenPaymentSuccessful() {
        let amount: Double = 12.99
        let sut = buildSUT(forAmount: amount)

        sut.appearedOnScreen()
        sut.onPurchaseConfirmed()
        paymentServiceSpy.paymentSucceeded(at: 0)

        XCTAssertTrue(firebaseAnalyticsServiceStub.containsRecordedEvent(.purchaseEvent(amount)))
        XCTAssertTrue(facebookAnalyticsServiceStub.containsRecordedEvent(.purchaseEvent(amount)))
    }

    func testPurchaseEventTrackedWhenPaymentFailed() {
        let amount: Double = 12.99
        let sut = buildSUT(forAmount: amount)

        sut.appearedOnScreen()
        sut.onPurchaseConfirmed()
        paymentServiceSpy.paymentFailed(at: 0)

        XCTAssertFalse(firebaseAnalyticsServiceStub.containsRecordedEvent(.purchaseEvent(amount)))
        XCTAssertFalse(facebookAnalyticsServiceStub.containsRecordedEvent(.purchaseEvent(amount)))
    }

    private func buildSUT(forAmount amount: Double) -> PaymentViewOutputs {
        let paymentComposer = PaymentComposer(
            providePaymentService: { [unowned self] in self.paymentServiceSpy }, provideFirebaseAnalyticsService: { [unowned self] in self.firebaseAnalyticsServiceStub },
            provideFacebookAnalyticsService: { [unowned self] in self.facebookAnalyticsServiceStub }
        )
        let paymentScene = paymentComposer
            .composePaymentScene(for: amount, with: PaymentSceneOutputsStub()) as! PaymentViewController
        return paymentScene.outputs!
    }
}

private final class PaymentSceneOutputsStub: PaymentSceneOutputs {
    func onPurchaseCompleted() {}
}
