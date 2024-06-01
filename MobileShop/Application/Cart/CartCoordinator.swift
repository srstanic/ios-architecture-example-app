//
//  CartCoordinator.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import UIKit

public protocol CartComposing {
    func composeCartScene(with outputs: CartSceneOutputs) -> UIViewController
}

public protocol PaymentCoordinating {
    func transitionToPaymentScene(
        with amount: Double,
        over viewController: UIViewController,
        animated: Bool
    )
}

public final class CartCoordinator {
    public struct Dependencies {
        let composer: CartComposing
        let paymentCoordinator: PaymentCoordinating

        public init(composer: CartComposing, paymentCoordinator: PaymentCoordinating) {
            self.composer = composer
            self.paymentCoordinator = paymentCoordinator
        }
    }

    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    private let dependencies: Dependencies
    private weak var navigationController: UINavigationController?

    public func transitionToCartScene(in navigationController: UINavigationController, animated: Bool) {
        let cartScene = dependencies.composer.composeCartScene(with: self)
        navigationController.pushViewController(cartScene, animated: animated)
        self.navigationController = navigationController
    }
}

extension CartCoordinator: CartSceneOutputs {
    public func onDidChooseToPay(for amount: Double) {
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
