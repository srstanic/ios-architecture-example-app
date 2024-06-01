//
//  PaymentCoordinator.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import UIKit

public protocol PaymentComposing {
    func composePaymentScene(
        for amount: Double,
        with outputs: PaymentSceneOutputs
    ) -> UIViewController
}

public final class PaymentCoordinator {
    public struct Dependencies {
        let composer: PaymentComposing

        init(composer: PaymentComposing) {
            self.composer = composer
        }
    }

    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    private let dependencies: Dependencies
    private weak var presentingViewController: UIViewController?

    public func transitionToPaymentScene(
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
    public func onPurchaseCompleted() {
        presentingViewController?.dismiss(animated: true)
    }
}
