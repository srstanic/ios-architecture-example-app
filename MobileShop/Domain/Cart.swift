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
}

