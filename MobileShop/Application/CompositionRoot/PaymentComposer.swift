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
    private let providePaymentService: () -> PaymentService
    private let provideFirebaseAnalyticsService: () -> FirebaseAnalyticsService
    private let provideFacebookAnalyticsService: () -> FacebookAnalyticsService

    init(
        providePaymentService: @escaping () -> PaymentService,
        provideFirebaseAnalyticsService: @escaping () -> FirebaseAnalyticsService,
        provideFacebookAnalyticsService: @escaping () -> FacebookAnalyticsService
    ) {
        self.providePaymentService = providePaymentService
        self.provideFirebaseAnalyticsService = provideFirebaseAnalyticsService
        self.provideFacebookAnalyticsService = provideFacebookAnalyticsService
    }

    func composePaymentScene(
        for amount: Double,
        with outputs: PaymentSceneOutputs
    ) -> UIViewController {
        let paymentViewController: PaymentViewController = .initFromStoryboard()

        let firebaseAnalyticsService = provideFirebaseAnalyticsService()
        let facebookAnalyticsService = provideFacebookAnalyticsService()
        let paymentService = PaymentSceneAnalyticsDecorators.PaymentServiceDecorator(
            decoratee: providePaymentService(),
            firebaseAnalyticsService: firebaseAnalyticsService,
            facebookAnalyticsService: facebookAnalyticsService
        )
        let localizer = NSLocalizer(forType: PaymentPresenter.self, tableName: "Payment")
        let presenter = PaymentPresenter(
            for: amount,
            dependencies: .init(
                paymentService: paymentService,
                localizer: localizer
            ),
            outputs: outputs
        )

        let viewOutputs = PaymentSceneAnalyticsDecorators.PaymentViewOutputsDecorator(
            decoratee: presenter,
            firebaseAnalyticsService: firebaseAnalyticsService
        )

        paymentViewController.outputs = viewOutputs
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
