//
//  CartTracker.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

final class CartTracker: FirebaseTracker, CartTracking {
    func onDidVisitScene() {
        firebaseAnalyticsService.logSceneVisit(titled: "Cart")
    }

    func onDidChooseToPay() {
        firebaseAnalyticsService.logUserAction(titled: "Pay")
    }
}
