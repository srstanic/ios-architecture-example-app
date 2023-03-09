//
//  PaymentComposer.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import UIKit


protocol PaymentComposing {
    func composePaymentScene(
        for amount: Double,
        with outputs: PaymentSceneOutputs
    ) -> UIViewController
}

final class PaymentComposer: PaymentComposing {
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
        presenter.view = WeakReferenceProxy(paymentViewController)

        return paymentViewController
    }
}

extension WeakReferenceProxy: PaymentView where ReferenceType: PaymentView {
    func setAmountTitle(_ amountTitle: String) {
        object?.setAmountTitle(amountTitle)
    }

    func setChargeNote(_ chargeNote: String) {
        object?.setChargeNote(chargeNote)
    }

    func setConfirmPurchaseButtonTitle(_ confirmPurchaseButtonTitle: String) {
        object?.setConfirmPurchaseButtonTitle(confirmPurchaseButtonTitle)
    }

    func showAmount(_ amount: String) {
        object?.showAmount(amount)
    }
}
