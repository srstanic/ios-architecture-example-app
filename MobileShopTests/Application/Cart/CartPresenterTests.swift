//
//  CartPresenterTests.swift
//  MobileShopTests
//
//  Created by Srđan Stanić on 09/12/2020.
//

import XCTest
@testable import MobileShop

class CartPresenterTests: XCTestCase {
    private var cartServiceStub: CartServiceStub!
    private var cartTracker: CartTracking!
    private var firebaseAnalyticsServiceStub: FirebaseAnalyticsServiceStub!
    private var localizerStub: LocalizerStub!
    private var cartSceneOutputsSpy: CartSceneOutputsSpy!
    private var cartViewSpy: CartViewSpy!

    override func setUpWithError() throws {
        cartServiceStub = CartServiceStub()
        firebaseAnalyticsServiceStub = FirebaseAnalyticsServiceStub()
        localizerStub = LocalizerStub()
        cartTracker = CartTracker(firebaseAnalyticsService: firebaseAnalyticsServiceStub)
        cartSceneOutputsSpy = CartSceneOutputsSpy()
        cartViewSpy = CartViewSpy()
    }

    private let cart = Cart(
        id: "1",
        products: [
            ProductCartItem(product: Product(id: "1", title: "producttitle1", price: 10), quantity: 2),
            ProductCartItem(product: Product(id: "2", title: "producttitle2", price: 20), quantity: 1)
        ],
        discounts: [
            Discount(id: "1", title: "discount1", amountAsPercentage: 10, productId: nil),
            Discount(id: "2", title: "discount2", amountAsPercentage: 20, productId: "2")
        ]
    )

    private lazy var cartTotal: Double = {
        return CartRules.calculateTotalPriceAmount(for: cart)
    }()

    func testCartShownOnLoad() {
        cartServiceStub.result = .success(cart)

        let sut = buildSUT()
        sut.view = cartViewSpy

        sut.onViewDidLoad()

        XCTAssertEqual(cartViewSpy.recordedTitles, ["CART_SCENE_TITLE"])
        XCTAssertEqual(cartViewSpy.recordedPayButtonTitles, ["CART_SCENE_PAY_BUTTON_TITLE"])

        XCTAssertEqual(cartViewSpy.recordedLoadingIndicatorHidden, [false, true])

        XCTAssertEqual(cartViewSpy.recordedContents.count, 1)
        let viewContent = cartViewSpy.recordedContents.first!

        let productContents = viewContent.products
        XCTAssertEqual(productContents.map(\.title), cart.products.map(\.product.title))
        XCTAssertEqual(productContents.map(\.discount), [nil, "CART_SCENE_DISCOUNT_VALUE,20"])
        XCTAssertEqual(
            productContents.map(\.quantity),
            cart.products.map { "CART_SCENE_QUANTITY_VALUE,\($0.quantity)"}
        )
        XCTAssertEqual(
            productContents.map(\.price),
            cart.products.map { "PRICE_AMOUNT,\($0.product.price)" }
        )

        let discountContents = viewContent.discounts
        XCTAssertEqual(discountContents.map(\.title), ["discount1"])
        XCTAssertEqual(discountContents.map(\.discount), ["CART_SCENE_DISCOUNT_VALUE,10"])

        XCTAssertEqual(viewContent.total.amount, "PRICE_AMOUNT,32.40")
    }

    func testCartErrorOnLoad() {
        cartServiceStub.result = .failure(CartServiceError.failedToLoadCartData)

        let sut = buildSUT()
        sut.view = cartViewSpy

        sut.onViewDidLoad()

        XCTAssertEqual(cartViewSpy.recordedTitles, ["CART_SCENE_TITLE"])
        XCTAssertEqual(cartViewSpy.recordedPayButtonTitles, ["CART_SCENE_PAY_BUTTON_TITLE"])

        XCTAssertEqual(cartViewSpy.recordedLoadingIndicatorHidden, [false, true])

        XCTAssertEqual(cartViewSpy.recordedContents.count, 0)

        let expectedAlertContent = RecordedAlertContent(
            title: "CART_SCENE_ERROR_TITLE",
            message: "CART_SCENE_ERROR_MESSAGE",
            actionTitles: ["CART_SCENE_ERROR_ACTION_TITLE"]
        )
        XCTAssertEqual(cartViewSpy.recordedAlertContents, [expectedAlertContent])

        // let's retry

        cartServiceStub.result = .success(cart)
        cartViewSpy.recordedOnDismissHandlers.first!?()

        XCTAssertEqual(cartViewSpy.recordedLoadingIndicatorHidden, [false, true, false, true])
        XCTAssertEqual(cartViewSpy.recordedContents.map(\.total.amount), ["PRICE_AMOUNT,32.40"])
    }

    func testDidChooseToPay() {
        cartServiceStub.result = .success(cart)

        let sut = buildSUT()

        sut.onViewDidLoad()
        sut.onPaymentInitiated()

        XCTAssertEqual(cartSceneOutputsSpy.recordedOnDidChooseToPayAmounts, [cartTotal])
    }

    func testTrackingVisit() {
        let sut = buildSUT()

        sut.onViewDidAppear()

        XCTAssertEqual(firebaseAnalyticsServiceStub.recordedEvents, [.sceneVisitEvent("Cart")])
    }

    func testTrackingPaymentInitiated() {
        let sut = buildSUT()

        sut.onPaymentInitiated()

        XCTAssertEqual(firebaseAnalyticsServiceStub.recordedEvents, [.userActionEvent("Pay")])
    }

    private func buildSUT() -> CartPresenter {
        return CartPresenter(
            dependencies: .init(
                cartService: cartServiceStub,
                localizer: localizerStub,
                tracker: cartTracker
            ),
            outputs: cartSceneOutputsSpy
        )
    }
}

final class CartServiceStub: CartServicing {
    func getCart(completion: @escaping CartResultHandler) {
        if let result = self.result {
            completion(result)
        }
    }
    var result: Result<Cart, Error>? = nil
}

final class CartSceneOutputsSpy: CartSceneOutputs {
    func onDidChooseToPay(for amount: Double) {
        recordedOnDidChooseToPayAmounts.append(amount)
    }
    var recordedOnDidChooseToPayAmounts: [Double] = []
}

final class CartViewSpy: AlertingViewStub, CartView {
    func setLoadingIndicatorVisibility(isHidden: Bool) {
        recordedLoadingIndicatorHidden.append(isHidden)
    }
    var recordedLoadingIndicatorHidden: [Bool] = []

    func setPayButtonTitle(_ title: String) {
        recordedPayButtonTitles.append(title)
    }
    var recordedPayButtonTitles: [String] = []

    func setTitle(_ title: String) {
        recordedTitles.append(title)
    }
    var recordedTitles: [String] = []

    func showCartContent(_ cartContent: CartViewContent) {
        recordedContents.append(cartContent)
    }
    var recordedContents: [CartViewContent] = []
}
