//
//  FacebookTracker.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

class FacebookTracker {
    init(facebookAnalyticsService: FacebookAnalyticsService) {
        self.facebookAnalyticsService = facebookAnalyticsService

    }
    let facebookAnalyticsService: FacebookAnalyticsService
}
