//
//  FirebaseTracker.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

class FirebaseTracker {
    init(firebaseAnalyticsService: FirebaseAnalyticsService) {
        self.firebaseAnalyticsService = firebaseAnalyticsService

    }
    let firebaseAnalyticsService: FirebaseAnalyticsService
}
