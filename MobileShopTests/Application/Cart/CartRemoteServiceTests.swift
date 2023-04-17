//
//  CartRemoteServiceTests.swift
//  MobileShopTests
//
//  Created by Srđan Stanić on 09/12/2020.
//

import XCTest
@testable import MobileShop

class CartRemoteServiceTests: XCTestCase {
    func testGetCartSuccessfullyLoadsCart() {
        let cartResultExpectation = expectation(description: "Expected get cart result")

        let (sut, apiClientStub) = buildSUT()
        apiClientStub.cartResult = .success(Self.remoteStoreCart)
        apiClientStub.productsResult = .success(Self.remoteStoreProducts)
        apiClientStub.discountsResult = .success(Self.remoteStoreDiscounts)

        sut.loadCart { result in
            if case let .success(cart) = result {
                XCTAssertEqual(cart.id, Self.remoteStoreCart.id)
                XCTAssertEqual(cart.products.map(\.quantity), Self.remoteStoreCart.productItems.map(\.quantity))
                XCTAssertEqual(cart.products.map(\.product.id), Self.remoteStoreProducts.map(\.id))
                XCTAssertEqual(cart.products.map(\.product.title), Self.remoteStoreProducts.map(\.title))
                XCTAssertEqual(cart.products.map(\.product.price), Self.remoteStoreProducts.map(\.price))
                XCTAssertEqual(cart.discounts.map(\.id), Self.remoteStoreDiscounts.map(\.id))
                XCTAssertEqual(cart.discounts.map(\.productId), Self.remoteStoreDiscounts.map(\.productId))
                XCTAssertEqual(cart.discounts.map(\.amountAsPercentage), Self.remoteStoreDiscounts.map(\.amountAsPercentage))
                cartResultExpectation.fulfill()
            } else {
                XCTFail("Expected to load cart data but got \(result) instead.")
            }
        }
        waitForExpectations(timeout: 0.1)
    }

    func testGetCartFailsWhenCartLoadFails() {
        let (sut, apiClientStub) = buildSUT()

        expect(sut, toFailWith: .failedToLoadCartData, when: {
            apiClientStub.cartResult = .failure(CartLoadingError.failedToLoadCartData)
            apiClientStub.productsResult = .success(Self.remoteStoreProducts)
            apiClientStub.discountsResult = .success(Self.remoteStoreDiscounts)

        })
    }

    func testGetCartFailsWhenProductsLoadFails() {
        let (sut, apiClientStub) = buildSUT()

        expect(sut, toFailWith: .failedToLoadCartData, when: {
            apiClientStub.cartResult = .success(Self.remoteStoreCart)
            apiClientStub.productsResult = .failure(CartLoadingError.failedToLoadCartData)
            apiClientStub.discountsResult = .success(Self.remoteStoreDiscounts)

        })
    }

    func testGetCartFailsWhenDiscountsLoadFails() {
        let (sut, apiClientStub) = buildSUT()

        expect(sut, toFailWith: .failedToLoadCartData, when: {
            apiClientStub.cartResult = .success(Self.remoteStoreCart)
            apiClientStub.productsResult = .success(Self.remoteStoreProducts)
            apiClientStub.discountsResult = .failure(CartLoadingError.failedToLoadCartData)

        })
    }

    private func expect(
        _ sut: CartLoading,
        toFailWith expectedError: CartLoadingError,
        when closure: VoidHandler,
        file: StaticString = #filePath, line: UInt = #line
    ) {
        let cartResultExpectation = expectation(description: "Expected get cart result")

        closure()

        sut.loadCart { result in
            if case let .failure(error) = result {
                XCTAssertEqual(error as? CartLoadingError, expectedError)
                cartResultExpectation.fulfill()
            } else {
                XCTFail("Expected to get load error but got \(result) instead.")
            }
        }
        waitForExpectations(timeout: 0.1)
    }

    private func buildSUT() -> (CartLoading, MockMobileShopAPIClientStub) {
        let apiClientStub = MockMobileShopAPIClientStub()
        let cartLoader: CartRemoteService = CartRemoteService(apiClient: apiClientStub)
        return (cartLoader, apiClientStub)
    }

    fileprivate static let remoteStoreCart: RemoteStoreCart = {
        let productItems: [RemoteStoreProductCartItem] = [
            .init(productId: "1", quantity: 2),
            .init(productId: "2", quantity: 1),
            .init(productId: "3", quantity: 1)
            ]
        let cart = RemoteStoreCart(
            id: "1",
            productItems: productItems,
            discountIds: ["1", "2"]
        )
        return cart
    }()

    fileprivate static let remoteStoreDiscounts: [RemoteStoreDiscount] = [
        .init(id: "1", title: "Coupon discount", amountAsPercentage: 5, productId: nil),
        .init(id: "2", title: "Clearance", amountAsPercentage: 10, productId: "2")
    ]

    fileprivate static let remoteStoreProducts: [RemoteStoreProduct] = [
        .init(id: "1", title: "Cotton T-shirt", price: 19.99),
        .init(id: "2", title: "Premium T-shirt", price: 29.99),
        .init(id: "3", title: "Baseball cap", price: 21.99)
    ]
}

private final class MockMobileShopAPIClientStub: MobileShopAPIClient {
    var cartResult: Result<RemoteStoreCart, Error>?
    var productsResult: Result<[RemoteStoreProduct], Error>?
    var discountsResult: Result<[RemoteStoreDiscount], Error>?

    func request<ModelType: Codable>(_ request: MobileShopAPIRequest, completion: @escaping (Result<ModelType, Error>) -> Void) {
        if
            request.path == "cart",
            let result = cartResult as? Result<ModelType, Error>
        {
            completion(result)
        } else if
            request.path == "products",
            let result = productsResult as? Result<ModelType, Error>
        {
            completion(result)
        } else if
            request.path == "discounts",
            let result = discountsResult as? Result<ModelType, Error>
        {
            completion(result)
        }
    }
}
