//
//  CartCoordinator.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import UIKit

protocol CartCoordinating {
    func transitionToCartScene(in navigationController: UINavigationController, animated: Bool)
}

final class CartCoordinator: CartCoordinating {
    struct Dependencies {
        let paymentCoordinator: PaymentCoordinating
    }

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    private let dependencies: Dependencies

    func transitionToCartScene(in navigationController: UINavigationController, animated: Bool) {
        let cartScene = cartBuilder.buildCartScene(with: self)
        navigationController.pushViewController(cartScene, animated: animated)
        self.navigationController = navigationController
    }

    private let cartBuilder = CartBuilder()
    private weak var navigationController: UINavigationController?
}

extension CartCoordinator: CartControllerDelegate {
    func didChooseToPay(for amount: Double) {
        guard let navigationController = self.navigationController else {
            return
        }
        dependencies.paymentCoordinator.transitionToPaymentScene(
            with: amount,
            over: navigationController,
            animated: true
        )
    }
}
