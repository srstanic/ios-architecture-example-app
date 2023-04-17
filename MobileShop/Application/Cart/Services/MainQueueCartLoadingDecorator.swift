//
//  MainQueueCartLoadingDecorator.swift
//  MobileShop
//
//  Created by Srđan Stanić on 17.04.2023..
//

import Foundation

final class MainQueueCartLoadingDecorator: CartLoading {
    private let decoratee: CartLoading

    init(decoratee: CartLoading) {
        self.decoratee = decoratee
    }

    func loadCart(completion: @escaping CartResultHandler) {
        decoratee.loadCart { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
