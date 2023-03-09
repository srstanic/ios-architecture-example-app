//
//  PaymentCoordinator.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import UIKit

protocol PaymentCoordinating {
    func transitionToPaymentScene(
        with amount: Double,
        over viewController: UIViewController,
        animated: Bool
    )
}

final class PaymentCoordinator: PaymentCoordinating {
    struct Dependencies {
        let composer: PaymentComposing
    }

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    private let dependencies: Dependencies
    private weak var presentingViewController: UIViewController?

    func transitionToPaymentScene(
        with amount: Double,
        over viewController: UIViewController,
        animated: Bool
    ) {
        let paymentScene = dependencies.composer.composePaymentScene(for: amount, with: self)
        viewController.present(paymentScene, animated: true)
        self.presentingViewController = viewController
    }
}

extension PaymentCoordinator: PaymentSceneOutputs {
    func onPurchaseCompleted() {
        presentingViewController?.dismiss(animated: true)
    }
}
