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
    func transitionToPaymentScene(
        with amount: Double,
        over viewController: UIViewController,
        animated: Bool
    ) {
        let paymentScene = composer.composePaymentScene(for: amount, with: self)
        viewController.present(paymentScene, animated: true)
        self.presentingViewController = viewController
    }

    private let composer = PaymentComposer()
    private weak var presentingViewController: UIViewController!
}

extension PaymentCoordinator: PaymentSceneOutputs {
    func onPurchaseCompleted() {
        presentingViewController.dismiss(animated: true)
    }
}
