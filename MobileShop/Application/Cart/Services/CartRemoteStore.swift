//
//  CartRemoteStore.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

typealias RemoteStoreCartResultHandler = (Result<RemoteStoreCart, Error>) -> Void

struct RemoteStoreCart: Codable {
    let id: String
    let productItems: [RemoteStoreProductCartItem]
    let discountIds: [String]
}

struct RemoteStoreProductCartItem: Codable {
    let productId: String
    let quantity: Int
}

final class CartRemoteStore: MobileShopRemoteStore {
    func getCart(completion: @escaping RemoteStoreCartResultHandler) {
        apiClient.request(path: "cart", completion: completion)
    }
}
