//
//  CartSceneAnalyticsTests.swift
//  MobileShopTests
//
//  Created by Srđan Stanić on 13.03.2023.
//

import XCTest
import MobileShop

final class CartSceneAnalyticsTests: XCTestCase {
    private var firebaseAnalyticsServiceStub: FirebaseAnalyticsServiceStub!

    override func setUp() {
        firebaseAnalyticsServiceStub = FirebaseAnalyticsServiceStub()
    }

    func testDidVisitSceneEventTracked() {
        let sut = buildSUT()

        sut.appearedOnScreen()

        XCTAssertTrue(firebaseAnalyticsServiceStub.containsRecordedEvent(.sceneVisitEvent("Cart")))
    }

    func testUserTappedToPayEventTracked() {
        let sut = buildSUT()

        sut.appearedOnScreen()
        sut.onPaymentInitiated()

        XCTAssertTrue(firebaseAnalyticsServiceStub.containsRecordedEvent(.userActionEvent("Pay")))
    }

    private func buildSUT() -> CartViewOutputs {
        let cartComposer = CartComposer(
            provideFirebaseAnalyticsService: { [unowned self] in self.firebaseAnalyticsServiceStub }
        )
        let cartScene = cartComposer
            .composeCartScene(with: CartSceneOutputsStub()) as! CartViewController
        return cartScene.outputs!
    }
}

private final class CartSceneOutputsStub: CartSceneOutputs {
    func onDidChooseToPay(for amount: Double) {}
}
