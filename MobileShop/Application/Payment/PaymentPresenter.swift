//
//  PaymentPresenter.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

// MARK: PaymentView & PaymentViewOutputs

protocol PaymentView: AlertingView {
    func setAmountTitle(_ amountTitle: String)
    func setChargeNote(_ chargeNote: String)
    func setConfirmPurchaseButtonTitle(_ confirmPurchaseButtonTitle: String)
    func showAmount(_ amount: String)
}

protocol PaymentViewOutputs: ViewOutputs {
    func onPurchaseConfirmed()
}

// MARK: PaymentSceneOutputs

protocol PaymentSceneOutputs {
    func onPurchaseCompleted()
}

// MARK: PaymentTracking

protocol PaymentTracking: SceneTracking {
    func onDidConfirmPurchase()
    func onDidCompletePurchase(witAmount amount: Double)
}

final class PaymentPresenter: PaymentViewOutputs {
    struct Dependencies {
        let tracker: PaymentTracking
        let localizer: Localizing
    }

    init(for amount: Double, dependencies: Dependencies, outputs: PaymentSceneOutputs) {
        self.amount = amount
        self.dependencies = dependencies
        self.outputs = outputs
    }
    private let amount: Double
    private let dependencies: Dependencies
    private let outputs: PaymentSceneOutputs

    var view: PaymentView?

    // MARK: PaymentViewOutputs

    func onPurchaseConfirmed() {
        dependencies.tracker.onDidConfirmPurchase()
        // If this was a real app, there would be some transaction processing logic here
        // but since this is just an example, we'll assume the transaction went through
        // and show a success message.
        dependencies.tracker.onDidCompletePurchase(witAmount: amount)
        showSuccessfulPurchaseAlert() { [outputs] in
            outputs.onPurchaseCompleted()
        }
    }

    private func showSuccessfulPurchaseAlert(onDismiss: @escaping VoidHandler) {
        let title = dependencies.localizer.localize(.successAlertTitle)
        let message = dependencies.localizer.localize(.successAlertMessage)
        let buttonTitle = dependencies.localizer.localize(.successAlertButtonTitle)
        view?.showAlert(
            title: title,
            message: message,
            actions: [AlertAction(title: buttonTitle)],
            onDismiss: onDismiss
        )
    }

    func onViewDidLoad() {
        view?.setAmountTitle(dependencies.localizer.localize(.amountTitle))
        view?.setChargeNote(dependencies.localizer.localize(.chargeNote))
        view?.setConfirmPurchaseButtonTitle(dependencies.localizer.localize(.confirmPurchaseButtonTitle))
        view?.showAmount(dependencies.localizer.localize(.priceAmount, String(format: "%.2f", amount)))
    }

    func onViewWillAppear() {}

    func onViewDidAppear() {
        dependencies.tracker.onDidVisitScene()
    }

    func onViewDidDisappear() {}
}

private extension String {
    static let amountTitle = "PAYMENT_SCENE_AMOUNT_TITLE"
    static let priceAmount = "PAYMENT_SCENE_PRICE_AMOUNT"
    static let chargeNote = "PAYMENT_SCENE_CHARGE_NOTE"
    static let confirmPurchaseButtonTitle = "PAYMENT_SCENE_CONFIRM_PURCHASE_BUTTON_TITLE"
    static let successAlertTitle = "PAYMENT_SUCCESS_ALERT_TITLE"
    static let successAlertMessage = "PAYMENT_SUCCESS_ALERT_MESSAGE"
    static let successAlertButtonTitle = "PAYMENT_SUCCESS_ALERT_BUTTON_TITLE"
}
