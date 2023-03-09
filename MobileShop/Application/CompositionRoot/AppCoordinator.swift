//
//  AppCoordinator.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import UIKit

final class AppCoordinator {
    let cartCoordinator: CartCoordinating

    init(cartCoordinator: CartCoordinating) {
        self.cartCoordinator = cartCoordinator
    }

    func start(on window: UIWindow) {
        let navigationController = UINavigationController()
        cartCoordinator.transitionToCartScene(in: navigationController, animated: false)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
