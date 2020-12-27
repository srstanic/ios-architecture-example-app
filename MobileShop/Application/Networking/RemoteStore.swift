//
//  RemoteStore.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

class RemoteStore {
    init(apiClient: RemoteApiClient) {
        self.apiClient = apiClient
    }
    let apiClient: RemoteApiClient
}
