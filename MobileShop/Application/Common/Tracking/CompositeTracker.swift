//
//  CompositeTracker.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

class CompositeTracker {
    init(
        firebaseAnalyticsService: FirebaseAnalyticsService,
        facebookAnalyticsService: FacebookAnalyticsService
    ) {
        self.firebaseAnalyticsService = firebaseAnalyticsService
        self.facebookAnalyticsService = facebookAnalyticsService
    }
    let firebaseAnalyticsService: FirebaseAnalyticsService
    let facebookAnalyticsService: FacebookAnalyticsService
}
