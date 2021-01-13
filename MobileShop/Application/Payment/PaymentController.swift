//
//  PaymentController.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

// MARK: PaymentView & PaymentViewDelegate

protocol PaymentView: class, AlertingView {
    func setAmountTitle(_ amountTitle: String)
    func setChargeNote(_ chargeNote: String)
    func setConfirmPurchaseButtonTitle(_ confirmPurchaseButtonTitle: String)
    func showAmount(_ amount: String)
}

protocol PaymentViewDelegate: ViewDelegate {
    func onPurchaseConfirmed()
}

// MARK: PaymentControllerDelegate

protocol PaymentControllerDelegate {
    func onPurchaseCompleted()
}

// MARK: PaymentTracking

protocol PaymentTracking: SceneTracking {
    func onDidConfirmPurchase()
    func onDidCompletePurchase(witAmount amount: Double)
}

final class PaymentController: PaymentViewDelegate {
    struct Dependencies {
        let tracker: PaymentTracking
        let localizer: Localising
    }

    init(for amount: Double, dependencies: Dependencies, delegate: PaymentControllerDelegate) {
        self.amount = amount
        self.dependencies = dependencies
        self.delegate = delegate
    }
    private let amount: Double
    private let dependencies: Dependencies
    private let delegate: PaymentControllerDelegate

    weak var view: PaymentView?

    // MARK: PaymentViewDelegate

    func onPurchaseConfirmed() {
        dependencies.tracker.onDidConfirmPurchase()
        // If this was a real app, there would be some transaction processing logic here
        // but since this is just an example, we'll assume the transaction went through
        // and show a success message.
        dependencies.tracker.onDidCompletePurchase(witAmount: amount)
        showSuccessfulPurchaseAlert() { [delegate] in
            delegate.onPurchaseCompleted()
        }
    }

    private func showSuccessfulPurchaseAlert(onDismiss: @escaping VoidHandler) {
        let title = dependencies.localizer.localize("PAYMENT_SUCCESS_ALERT_TITLE")
        let message = dependencies.localizer.localize("PAYMENT_SUCCESS_ALERT_MESSAGE")
        let buttonTitle = dependencies.localizer.localize("PAYMENT_SUCCESS_ALERT_BUTTON_TITLE")
        view?.showAlert(
            title: title,
            message: message,
            actions: [AlertAction(title: buttonTitle)],
            onDismiss: onDismiss
        )
    }

    func onViewDidLoad() {
        view?.setAmountTitle(dependencies.localizer.localize("PAYMENT_SCENE_AMOUNT_TITLE"))
        view?.setChargeNote(dependencies.localizer.localize("PAYMENT_SCENE_CHARGE_NOTE"))
        view?.setConfirmPurchaseButtonTitle(
            dependencies.localizer.localize("PAYMENT_SCENE_CONFIRM_PURCHASE_BUTTON_TITLE")
        )
        view?.showAmount(dependencies.localizer.localize("PRICE_AMOUNT", String(format: "%.2f", amount)))
    }

    func onViewWillAppear() {}

    func onViewDidAppear() {
        dependencies.tracker.onDidVisitScene()
    }

    func onViewDidDisappear() {}
}
