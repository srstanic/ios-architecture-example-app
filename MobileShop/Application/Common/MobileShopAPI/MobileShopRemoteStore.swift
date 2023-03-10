//
//  MobileShopRemoteStore.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

class MobileShopRemoteStore {
    init(apiClient: MobileShopAPIClient) {
        self.apiClient = apiClient
    }
    let apiClient: MobileShopAPIClient
}
