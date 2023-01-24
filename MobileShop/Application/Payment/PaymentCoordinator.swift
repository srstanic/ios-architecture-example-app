//
//  PaymentCoordinator.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import UIKit

final class PaymentDestination {
    let amount: Double
    let presentingViewController: UIViewController
    let animated: Bool

    init(amount: Double, presentingViewController: UIViewController, animated: Bool) {
        self.amount = amount
        self.presentingViewController = presentingViewController
        self.animated = animated
    }
}

final class PaymentCoordinator: Coordinating {
    func transition(to destination: PaymentDestination) {
        let paymentScene = builder.buildPaymentScene(for: destination.amount, with: self)
        let presentingViewController = destination.presentingViewController
        presentingViewController.present(paymentScene, animated: true)
        self.presentingViewController = presentingViewController
    }

    private let builder = PaymentBuilder()
    private weak var presentingViewController: UIViewController!
}

extension PaymentCoordinator: PaymentControllerDelegate {
    func onPurchaseCompleted() {
        presentingViewController.dismiss(animated: true)
    }
}
