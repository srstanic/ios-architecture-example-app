//
//  Discount.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

public struct Discount {
    public let id: String
    public let title: String
    public let amountAsPercentage: Int
    public let productId: String?

    public init(id: String, title: String, amountAsPercentage: Int, productId: String? = nil) {
        self.id = id
        self.title = title
        self.amountAsPercentage = amountAsPercentage
        self.productId = productId
    }
}
