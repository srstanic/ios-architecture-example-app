//
//  CartCoordinator.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import UIKit

final class CartDestination {
    let navigationController: UINavigationController
    let animated: Bool

    init(navigationController: UINavigationController, animated: Bool) {
        self.navigationController = navigationController
        self.animated = animated
    }
}

final class CartCoordinator: Coordinating {
    struct Dependencies {
        let paymentCoordinator: any Coordinating<PaymentDestination>
    }

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    private let dependencies: Dependencies

    func transition(to destination: CartDestination) {
        let cartScene = composer.composeCartScene(with: self)
        let navigationController = destination.navigationController
        navigationController.pushViewController(cartScene, animated: destination.animated)
        self.navigationController = navigationController
    }

    private let composer = CartComposer()
    private weak var navigationController: UINavigationController?
}

extension CartCoordinator: CartSceneOutputs {
    func onDidChooseToPay(for amount: Double) {
        guard let navigationController = self.navigationController else {
            return
        }
        let paymentDestination = PaymentDestination(
            amount: amount,
            presentingViewController: navigationController,
            animated: true
        )
        dependencies.paymentCoordinator.transition(to: paymentDestination)
    }
}
