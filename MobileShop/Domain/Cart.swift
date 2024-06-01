//
//  Cart.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

public struct Cart {
    public let id: String
    public let products: [ProductCartItem]
    public let discounts: [Discount]

    public init(id: String, products: [ProductCartItem], discounts: [Discount]) {
        self.id = id
        self.products = products
        self.discounts = discounts
    }
}

