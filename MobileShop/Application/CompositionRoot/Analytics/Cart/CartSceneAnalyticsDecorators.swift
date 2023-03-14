//
//  CartSceneAnalyticsDecorators.swift
//  MobileShop
//
//  Created by Srđan Stanić on 13.03.2023.
//

import Foundation

final class CartSceneAnalyticsDecorators {
    private init() {}

    final class CartViewOutputsDecorator: FirebaseTracker, CartViewOutputs {
        let decoratee: CartViewOutputs

        init(
            decoratee: CartViewOutputs,
            firebaseAnalyticsService: FirebaseAnalyticsService
        ) {
            self.decoratee = decoratee
            super.init(firebaseAnalyticsService: firebaseAnalyticsService)
        }

        func onViewDidLoad() {
            decoratee.onViewDidLoad()
        }

        func onViewWillAppear() {
            decoratee.onViewWillAppear()
        }

        func onViewDidAppear() {
            decoratee.onViewDidAppear()
            firebaseAnalyticsService.logSceneVisit(titled: "Cart")
        }

        func onViewDidDisappear() {
            decoratee.onViewDidDisappear()
        }

        func onPaymentInitiated() {
            firebaseAnalyticsService.logUserAction(titled: "Pay")
            decoratee.onPaymentInitiated()
        }
    }
}
