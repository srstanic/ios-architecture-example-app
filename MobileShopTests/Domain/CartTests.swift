//
//  CartTests.swift
//  MobileShopTests
//
//  Created by Srđan Stanić on 09/12/2020.
//

import XCTest
@testable import MobileShop

class CartTests: XCTestCase {

    func testEmptyCartTotal() throws {
        let sut = Cart(id: "1", products: [], discounts: [])

        XCTAssertEqual(sut.calculateTotalPriceAmount(), 0)
    }

    func testSingleProductTotal() throws {
        let productPrice: Double = 10
        let product = Product(id: "1", title: "p", price: productPrice)
        let productCartItem = ProductCartItem(product: product, quantity: 1)

        let sut = Cart(id: "1", products: [productCartItem], discounts: [])

        XCTAssertEqual(sut.calculateTotalPriceAmount(), productPrice)
    }

    func testSingleProductTwiceTotal() throws {
        let productPrice: Double = 10
        let quantity = 2
        let expectedPrice: Double = 20

        let product = Product(id: "1", title: "p", price: productPrice)
        let productCartItem = ProductCartItem(product: product, quantity: quantity)

        let sut = Cart(id: "1", products: [productCartItem], discounts: [])

        XCTAssertEqual(sut.calculateTotalPriceAmount(), expectedPrice)
    }

    func testTwoProductsTotal() throws {
        let productPrice1: Double = 10
        let productPrice2: Double = 8
        let expectedPrice: Double = 18

        let product1 = Product(id: "1", title: "p", price: productPrice1)
        let productCartItem1 = ProductCartItem(product: product1, quantity: 1)

        let product2 = Product(id: "2", title: "p", price: productPrice2)
        let productCartItem2 = ProductCartItem(product: product2, quantity: 1)

        let sut = Cart(id: "1", products: [productCartItem1, productCartItem2], discounts: [])

        XCTAssertEqual(sut.calculateTotalPriceAmount(), expectedPrice)
    }

    func testDiscountedProductTotal() throws {
        let productPrice: Double = 10
        let productDiscountPercentage: Int = 20
        let expectedPrice: Double = 8

        let product = Product(id: "1", title: "p", price: productPrice)
        let productCartItem = ProductCartItem(product: product, quantity: 1)

        let productDiscount = Discount(
            id: "1",
            title: "d",
            amountAsPercentage: productDiscountPercentage,
            productId: product.id
        )

        let sut = Cart(id: "1", products: [productCartItem], discounts: [productDiscount])

        XCTAssertEqual(sut.calculateTotalPriceAmount(), expectedPrice)
    }

    func testDiscountedProductAndDiscountedCartTotal() throws {
        let productPrice: Double = 10
        let productDiscountPercentage: Int = 20
        let cartDiscountPercentage: Int = 30
        let expectedPrice: Double = 5.6

        let product = Product(id: "1", title: "p", price: productPrice)
        let productCartItem = ProductCartItem(product: product, quantity: 1)

        let productDiscount = Discount(
            id: "1",
            title: "d",
            amountAsPercentage: productDiscountPercentage,
            productId: product.id
        )

        let cartDiscount = Discount(
            id: "2",
            title: "d",
            amountAsPercentage: cartDiscountPercentage,
            productId: nil
        )

        let sut = Cart(id: "1", products: [productCartItem], discounts: [productDiscount, cartDiscount])

        XCTAssertEqual(sut.calculateTotalPriceAmount(), expectedPrice)
    }
}
