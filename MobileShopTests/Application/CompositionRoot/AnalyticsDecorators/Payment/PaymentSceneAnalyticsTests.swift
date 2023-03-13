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

        sut.appearOnScreen()
        sut.tapOnPayButton()

        XCTAssertEqual(firebaseAnalyticsServiceStub.recordedEvents, [
            .sceneVisitEvent("Payment"),
            .userActionEvent("Confirm Purchase"),
            .purchaseEvent(amount)
        ])
        XCTAssertEqual(facebookAnalyticsServiceStub.recordedEvents, [.purchaseEvent(amount)])
    }

    private func buildSUT(forAmount amount: Double) -> PaymentViewController {
        let paymentComposer = PaymentSceneComposer(
            provideFirebaseAnalyticsServicing: { [unowned self] in self.firebaseAnalyticsServiceStub },
            provideFacebookAnalyticsServicing: { [unowned self] in self.facebookAnalyticsServiceStub }
        )
        let paymentScene = paymentComposer
            .composePaymentScene(for: amount, with: PaymentSceneOutputsStub()) as! PaymentViewController
        return paymentScene
    }
}

private final class PaymentSceneOutputsStub: PaymentSceneOutputs {
    func onPurchaseCompleted() {}
}

private extension PaymentViewController {
    func appearOnScreen() {
        loadViewIfNeeded()
        viewWillAppear(false)
        viewDidAppear(false)
    }

    func tapOnPayButton() {
        confirmPurchaseButton.simulateTap()
    }
}
