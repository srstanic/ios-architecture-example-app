//
//  Cart.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

struct Cart {
    let id: String
    let products: [ProductCartItem]
    let discounts: [Discount]

    func calculateTotalPriceAmount() -> Double {
        var discountsByProductIdMap: [String: Int] = [:]
        let productDiscounts = discounts.filter { $0.productId != nil }
        for discount in productDiscounts {
            discountsByProductIdMap[discount.productId!] = discount.amountAsPercentage
        }

        let totalProductsPrice = products
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

        let cartPrice = discounts
            .filter { $0.productId == nil }
            .map { $0.amountAsPercentage }
            .reduce(totalProductsPrice) { (result, discount) -> Double in
                return result * (1 - (Double(discount) / 100))
            }

        let roundedCartPrice = round(cartPrice * 100)/100
        return roundedCartPrice
    }
}

