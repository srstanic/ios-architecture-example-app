//
//  DiscountsRemoteStore.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

typealias RemoteStoreDiscountsResultHandler = (Result<[RemoteStoreDiscount], Error>) -> Void

struct RemoteStoreDiscount: Codable {
    let id: String
    let title: String
    let amountAsPercentage: Int
    let productId: String?
}

final class DiscountsRemoteStore: MobileShopRemoteStore {
    func getDiscounts(withIds discountIds: [String], completion: @escaping RemoteStoreDiscountsResultHandler) {
        apiClient.request(path: "discounts") { (discountsResult: Result<[RemoteStoreDiscount], Error>) in
            switch discountsResult {
            case .success(let allDiscounts):
                let discounts = allDiscounts.filter { discountIds.contains($0.id) }
                completion(.success(discounts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
