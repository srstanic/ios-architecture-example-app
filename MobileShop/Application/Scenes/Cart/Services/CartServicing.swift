//
//  CartServicing.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

protocol CartServicing {
    func getCart(completion: @escaping CartResultHandler)
}

typealias CartResultHandler = (Result<Cart, Error>) -> Void

enum CartServiceError: Error {
    case failedToLoadCartData
}
