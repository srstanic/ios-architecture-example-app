//
//  PaymentTracker.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

final class PaymentTracker: CompositeTracker, PaymentTracking {
    func onDidVisitScene() {
        firebaseAnalyticsService.logSceneVisit(titled: "Payment")
    }

    func onDidConfirmPurchase() {
        firebaseAnalyticsService.logUserAction(titled: "Confirm Purchase")
    }

    func onDidCompletePurchase(witAmount amount: Double) {
        firebaseAnalyticsService.logPurchase(withAmount: amount)
        facebookAnalyticsService.logPurchase(withAmount: amount)
    }
}
