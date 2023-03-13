//
//  PaymentSceneAnalyticsTests.swift
//  MobileShopTests
//
//  Created by Srđan Stanić on 13.03.2023.
//

import XCTest
@testable import MobileShop

final class PaymentSceneAnalyticsTests: XCTestCase {
    private var firebaseAnalyticsServiceStub: FirebaseAnalyticsServiceStub!
    private var facebookAnalyticsServiceStub: FacebookAnalyticsServiceStub!

    override func setUp() {
        firebaseAnalyticsServiceStub = FirebaseAnalyticsServiceStub()
        facebookAnalyticsServiceStub = FacebookAnalyticsServiceStub()
    }

    func testDidVisitSceneEventTracked() {
        let amount: Double = 12.99
        let sut = buildSUT(forAmount: amount)

        sut.appearedOnScreen()
        sut.onPurchaseConfirmed()

        XCTAssertEqual(firebaseAnalyticsServiceStub.recordedEvents, [
            .sceneVisitEvent("Payment"),
            .userActionEvent("Confirm Purchase"),
            .purchaseEvent(amount)
        ])
        XCTAssertEqual(facebookAnalyticsServiceStub.recordedEvents, [.purchaseEvent(amount)])
    }

    private func buildSUT(forAmount amount: Double) -> PaymentViewOutputs {
        let paymentComposer = PaymentComposer(
            provideFirebaseAnalyticsServicing: { [unowned self] in self.firebaseAnalyticsServiceStub },
            provideFacebookAnalyticsServicing: { [unowned self] in self.facebookAnalyticsServiceStub }
        )
        let paymentScene = paymentComposer
            .composePaymentScene(for: amount, with: PaymentSceneOutputsStub()) as! PaymentViewController
        return paymentScene.outputs!
    }
}

private final class PaymentSceneOutputsStub: PaymentSceneOutputs {
    func onPurchaseCompleted() {}
}

private extension PaymentViewOutputs {
    func appearedOnScreen() {
        onViewWillAppear()
        onViewDidAppear()
    }
}
