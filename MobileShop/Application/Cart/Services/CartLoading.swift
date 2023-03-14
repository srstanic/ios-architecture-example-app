//
//  CartLoading.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

typealias CartResultHandler = (Result<Cart, Error>) -> Void

protocol CartLoading {
    func loadCart(completion: @escaping CartResultHandler)
}

enum CartLoadingError: Error {
    case failedToLoadCartData
}
