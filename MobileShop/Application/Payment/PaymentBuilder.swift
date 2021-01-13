//
//  PaymentBuilder.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import UIKit

final class PaymentBuilder {
    func buildPaymentScene(
        for amount: Double,
        with delegate: PaymentControllerDelegate
    ) -> UIViewController {
        let paymentViewController: PaymentViewController = .initFromStoryboard()

        let paymentTracker = PaymentTracker(
            firebaseAnalyticsService: FirebaseAnalyticsService(),
            facebookAnalyticsService: FacebookAnalyticsService()
        )
        let localizer = Localizer()
        let controller = PaymentController(
            for: amount,
            dependencies: .init(
                tracker: paymentTracker,
                localizer: localizer
            ),
            delegate: delegate
        )

        paymentViewController.delegate = controller
        controller.view = paymentViewController

        return paymentViewController
    }
}
