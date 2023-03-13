//
//  PaymentSceneAnalyticsDecorators.swift
//  MobileShop
//
//  Created by Srđan Stanić on 13.03.2023.
//

import Foundation

final class PaymentSceneAnalyticsDecorators {
    private init() {}
    
    final class PaymentViewOutputsDecorator: FirebaseTracker, PaymentViewOutputs {
        let decoratee: PaymentViewOutputs

        init(
            decoratee: PaymentViewOutputs,
            firebaseAnalyticsService: FirebaseAnalyticsServicing
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
            firebaseAnalyticsService.logSceneVisit(titled: "Payment")
        }
        func onViewDidDisappear() {
            decoratee.onViewDidDisappear()
        }

        func onPurchaseConfirmed() {
            firebaseAnalyticsService.logUserAction(titled: "Confirm Purchase")
            decoratee.onPurchaseConfirmed()
        }
    }

    final class PaymentServiceDecorator: CompositeTracker, PaymentService {
        let decoratee: PaymentService

        init(
            decoratee: PaymentService,
            firebaseAnalyticsService: FirebaseAnalyticsServicing,
            facebookAnalyticsService: FacebookAnalyticsServicing
        ) {
            self.decoratee = decoratee
            super.init(
                firebaseAnalyticsService: firebaseAnalyticsService,
                facebookAnalyticsService: facebookAnalyticsService
            )
        }

        func processPayment(for amount: Double, completion: @escaping (Result<Void, Error>) -> Void) {
            decoratee.processPayment(for: amount) { [weak self] result in
                switch result {
                case .success:
                    self?.firebaseAnalyticsService.logPurchase(withAmount: amount)
                    self?.facebookAnalyticsService.logPurchase(withAmount: amount)
                case .failure:
                    break
                }
                completion(result)
            }
        }
    }
}

