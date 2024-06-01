//
//  CartRules.swift
//  MobileShop
//
//  Created by Srđan Stanić on 28.02.2021.
//

import Foundation

public final class CartRules {
    public static func calculateTotalPriceAmount(for cart: Cart) -> Double {
        var discountsByProductIdMap: [String: Int] = [:]
        let productDiscounts = cart.discounts.filter { $0.productId != nil }
        for discount in productDiscounts {
            discountsByProductIdMap[discount.productId!] = discount.amountAsPercentage
        }

        let totalProductsPrice = cart.products
            .reduce(0) { (result, productCartItem) -> Double in
                let totalFullProductPrice = Double(productCartItem.quantity) * productCartItem.product.price
                let totalProductPrice: Double
                if let productDiscount = discountsByProductIdMap[productCartItem.product.id] {
                    totalProductPrice = totalFullProductPrice * (1 - Double(productDiscount) / 100)
                } else {
                    totalProductPrice = totalFullProductPrice
                }
                return result + totalProductPrice
            }

        let cartPrice = cart.discounts
            .filter { $0.productId == nil }
            .map { $0.amountAsPercentage }
            .reduce(totalProductsPrice) { (result, discount) -> Double in
                return result * (1 - (Double(discount) / 100))
            }

        let roundedCartPrice = round(cartPrice * 100)/100
        return roundedCartPrice
    }
}
