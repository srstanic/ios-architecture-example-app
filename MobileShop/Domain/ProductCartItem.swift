//
//  ProductCartItem.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

public struct ProductCartItem {
    public let product: Product
    public let quantity: Int

    public init(product: Product, quantity: Int) {
        self.product = product
        self.quantity = quantity
    }
}
