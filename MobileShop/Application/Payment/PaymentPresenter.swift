//
//  PaymentPresenter.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

// MARK: PaymentView & PaymentViewOutputs

public protocol PaymentView: AlertingView {
    func setAmountTitle(_ amountTitle: String)
    func setChargeNote(_ chargeNote: String)
    func setConfirmPurchaseButtonTitle(_ confirmPurchaseButtonTitle: String)
    func showAmount(_ amount: String)
}

public protocol PaymentViewOutputs: ViewOutputs {
    func onPurchaseConfirmed()
}

// MARK: PaymentSceneOutputs

public protocol PaymentSceneOutputs {
    func onPurchaseCompleted()
}

public final class PaymentPresenter: PaymentViewOutputs {
    public struct Dependencies {
        let paymentService: PaymentService
        let localizer: Localizing

        public init(paymentService: PaymentService, localizer: Localizing) {
            self.paymentService = paymentService
            self.localizer = localizer
        }
    }

    public init(for amount: Double, dependencies: Dependencies, outputs: PaymentSceneOutputs) {
        self.amount = amount
        self.dependencies = dependencies
        self.outputs = outputs
    }
    private let amount: Double
    private let dependencies: Dependencies
    private let outputs: PaymentSceneOutputs

    public var view: PaymentView?

    // MARK: PaymentViewOutputs

    public func onPurchaseConfirmed() {
        dependencies.paymentService.processPayment(for: amount) { [weak self] result in
            switch result {
            case .success:
                self?.onSuccessfulPayment()
            case .failure:
                // TODO
                break
            }
        }
    }

    private func onSuccessfulPayment() {
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

    public func onViewDidLoad() {
        view?.setAmountTitle(dependencies.localizer.localize(.amountTitle))
        view?.setChargeNote(dependencies.localizer.localize(.chargeNote))
        view?.setConfirmPurchaseButtonTitle(dependencies.localizer.localize(.confirmPurchaseButtonTitle))
        view?.showAmount(dependencies.localizer.localize(.priceAmount, String(format: "%.2f", amount)))
    }

    public func onViewWillAppear() {}

    public func onViewDidAppear() {}

    public func onViewDidDisappear() {}
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
