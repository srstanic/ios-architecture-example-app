//
//  CartRemoteServiceTests.swift
//  MobileShopTests
//
//  Created by Srđan Stanić on 09/12/2020.
//

import XCTest
@testable import MobileShop

class CartRemoteServiceTests: XCTestCase {
    func testGetCart() throws {
        let sut = buildSUT()
        let cartResultExpectation = expectation(description: "Cart result received")
        sut.getCart { result in
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
                XCTFail()
            }
        }
        waitForExpectations(timeout: 0.1)
    }

    private func buildSUT() -> CartRemoteService {
        CartRemoteService(apiClient: MobileShopAPIClientStub())
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

fileprivate final class MobileShopAPIClientStub: MobileShopAPIClient {
    func request<ModelType: Codable>(_ request: MobileShopAPIRequest, completion: @escaping (Result<ModelType, Error>) -> Void) {
        if
            let model = CartRemoteServiceTests.remoteStoreCart as? ModelType,
            request.path == "cart"
        {
            completion(.success(model))
        } else if
            let model = CartRemoteServiceTests.remoteStoreProducts as? ModelType,
            request.path == "products"
        {
            completion(.success(model))
        } else if
            let model = CartRemoteServiceTests.remoteStoreDiscounts as? ModelType,
            request.path == "discounts"
        {
            completion(.success(model))
        }
    }
}
