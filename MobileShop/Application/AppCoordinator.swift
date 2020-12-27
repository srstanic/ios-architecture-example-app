//
//  AppCoordinator.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import UIKit

final class AppCoordinator {
    func start(on window: UIWindow) {
        let navigationController = UINavigationController()
        let cartCoordinator = Self.createCartCoordinator()
        cartCoordinator.transitionToCartScene(in: navigationController, animated: false)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    private static func createCartCoordinator() -> CartCoordinating {
        let paymentCoordinator = createPaymentCoordinator()
        let cartCoordinator = CartCoordinator(dependencies: .init(paymentCoordinator: paymentCoordinator))
        return cartCoordinator
    }

    private static func createPaymentCoordinator() -> PaymentCoordinating {
        return PaymentCoordinator()
    }
}
