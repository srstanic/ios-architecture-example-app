//
//  CompositeTracker.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

class CompositeTracker {
    init(
        firebaseAnalyticsService: FirebaseAnalyticsServicing,
        facebookAnalyticsService: FacebookAnalyticsServicing
    ) {
        self.firebaseAnalyticsService = firebaseAnalyticsService
        self.facebookAnalyticsService = facebookAnalyticsService
    }
    let firebaseAnalyticsService: FirebaseAnalyticsServicing
    let facebookAnalyticsService: FacebookAnalyticsServicing
}
