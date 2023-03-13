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
    private let provideFirebaseAnalyticsServicing: () -> FirebaseAnalyticsServicing
    private let provideFacebookAnalyticsServicing: () -> FacebookAnalyticsServicing
    init(
        provideFirebaseAnalyticsServicing: @escaping () -> FirebaseAnalyticsServicing,
        provideFacebookAnalyticsServicing: @escaping () -> FacebookAnalyticsServicing
    ) {
        self.provideFirebaseAnalyticsServicing = provideFirebaseAnalyticsServicing
        self.provideFacebookAnalyticsServicing = provideFacebookAnalyticsServicing
    }

    func composePaymentScene(
        for amount: Double,
        with outputs: PaymentSceneOutputs
    ) -> UIViewController {
        let paymentViewController: PaymentViewController = .initFromStoryboard()

        let paymentTracker = PaymentTracker(
            firebaseAnalyticsService: provideFirebaseAnalyticsServicing(),
            facebookAnalyticsService: provideFacebookAnalyticsServicing()
        )
        let localizer = NSLocalizer(forType: PaymentPresenter.self, tableName: "Payment")
        let presenter = PaymentPresenter(
            for: amount,
            dependencies: .init(
                paymentService: NullPaymentService(),
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
