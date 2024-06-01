//
//  CartPresenterTests.swift
//  MobileShopTests
//
//  Created by Srđan Stanić on 09/12/2020.
//

import XCTest
import MobileShop

class CartPresenterTests: XCTestCase {
    private var cartLoaderStub: CartLoaderStub!
    private var firebaseAnalyticsServiceStub: FirebaseAnalyticsServiceStub!
    private var localizerStub: LocalizerStub!
    private var cartSceneOutputsSpy: CartSceneOutputsSpy!
    private var cartViewSpy: CartViewSpy!

    override func setUpWithError() throws {
        cartLoaderStub = CartLoaderStub()
        firebaseAnalyticsServiceStub = FirebaseAnalyticsServiceStub()
        localizerStub = LocalizerStub()
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
        cartLoaderStub.result = .success(cart)

        let sut = buildSUT()
        sut.view = cartViewSpy

        sut.onViewDidLoad()

        XCTAssertEqual(cartViewSpy.recordedTitles, [localized("CART_SCENE_TITLE")])
        XCTAssertEqual(cartViewSpy.recordedPayButtonTitles, [localized("CART_SCENE_PAY_BUTTON_TITLE")])

        XCTAssertEqual(cartViewSpy.recordedLoadingIndicatorHidden, [false, true])

        XCTAssertEqual(cartViewSpy.recordedContents.count, 1)
        let viewContent = cartViewSpy.recordedContents.first!

        let productContents = viewContent.products
        XCTAssertEqual(productContents.map(\.title), cart.products.map(\.product.title))
        XCTAssertEqual(productContents.map(\.discount), [nil, localized("CART_SCENE_DISCOUNT_VALUE","20")])
        XCTAssertEqual(
            productContents.map(\.quantity),
            cart.products.map { localized("CART_SCENE_QUANTITY_VALUE","\($0.quantity)")}
        )
        XCTAssertEqual(
            productContents.map(\.price),
            cart.products.map { localized("CART_SCENE_PRICE_AMOUNT","\($0.product.price)") }
        )

        let discountContents = viewContent.discounts
        XCTAssertEqual(discountContents.map(\.title), ["discount1"])
        XCTAssertEqual(discountContents.map(\.discount), [localized("CART_SCENE_DISCOUNT_VALUE","10")])

        XCTAssertEqual(viewContent.total.amount, localized("CART_SCENE_PRICE_AMOUNT","32.40"))
    }

    func testCartErrorOnLoad() {
        cartLoaderStub.result = .failure(CartLoadingError.failedToLoadCartData)

        let sut = buildSUT()
        sut.view = cartViewSpy

        sut.onViewDidLoad()

        XCTAssertEqual(cartViewSpy.recordedTitles, [localized("CART_SCENE_TITLE")])
        XCTAssertEqual(cartViewSpy.recordedPayButtonTitles, [localized("CART_SCENE_PAY_BUTTON_TITLE")])

        XCTAssertEqual(cartViewSpy.recordedLoadingIndicatorHidden, [false, true])

        XCTAssertEqual(cartViewSpy.recordedContents.count, 0)

        let expectedAlertContent = RecordedAlertContent(
            title: localized("CART_SCENE_ERROR_TITLE"),
            message: localized("CART_SCENE_ERROR_MESSAGE"),
            actionTitles: [localized("CART_SCENE_ERROR_ACTION_TITLE")]
        )
        XCTAssertEqual(cartViewSpy.recordedAlertContents, [expectedAlertContent])

        // let's retry

        cartLoaderStub.result = .success(cart)
        cartViewSpy.recordedOnDismissHandlers.first!?()

        XCTAssertEqual(cartViewSpy.recordedLoadingIndicatorHidden, [false, true, false, true])
        XCTAssertEqual(cartViewSpy.recordedContents.map(\.total.amount), [localized("CART_SCENE_PRICE_AMOUNT","32.40")])
    }

    func testDidChooseToPay() {
        cartLoaderStub.result = .success(cart)

        let sut = buildSUT()

        sut.onViewDidLoad()
        sut.onPaymentInitiated()

        XCTAssertEqual(cartSceneOutputsSpy.recordedOnDidChooseToPayAmounts, [cartTotal])
    }

    private func buildSUT() -> CartPresenter {
        return CartPresenter(
            dependencies: .init(
                cartLoader: cartLoaderStub,
                localizer: localizerStub
            ),
            outputs: cartSceneOutputsSpy
        )
    }
}

final class CartLoaderStub: CartLoading {
    func loadCart(completion: @escaping CartResultHandler) {
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
