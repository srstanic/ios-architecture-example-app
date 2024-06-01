//
//  Product.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

public struct Product {
    public let id: String
    public let title: String
    public let price: Double

    public init(id: String, title: String, price: Double) {
        self.id = id
        self.title = title
        self.price = price
    }
}
