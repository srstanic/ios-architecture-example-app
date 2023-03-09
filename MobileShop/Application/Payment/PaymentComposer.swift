//
//  PaymentComposer.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import UIKit

final class PaymentComposer {
    func composePaymentScene(
        for amount: Double,
        with outputs: PaymentSceneOutputs
    ) -> UIViewController {
        let paymentViewController: PaymentViewController = .initFromStoryboard()

        let paymentTracker = PaymentTracker(
            firebaseAnalyticsService: FirebaseAnalyticsService(),
            facebookAnalyticsService: FacebookAnalyticsService()
        )
        let localizer = Localizer()
        let presenter = PaymentPresenter(
            for: amount,
            dependencies: .init(
                tracker: paymentTracker,
                localizer: localizer
            ),
            outputs: outputs
        )

        paymentViewController.outputs = presenter
        presenter.view = paymentViewController

        return paymentViewController
    }
}
