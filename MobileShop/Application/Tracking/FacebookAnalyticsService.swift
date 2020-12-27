//
//  FacebookAnalyticsService.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation
import FBSDKCoreKit

protocol FacebookAnalyticsServicing {
    func logEvent(_ event: String, parameters: [String: NSObject]?)
}

extension FacebookAnalyticsServicing {
    func logPurchase(withAmount amount: Double) {
        logEvent("purchase", parameters: ["amount": NSNumber(value: amount)])
    }
}

class FacebookAnalyticsService: FacebookAnalyticsServicing {
    func logEvent(_ event: String, parameters: [String : NSObject]?) {
        AppEvents.logEvent(.init(rawValue: event), parameters: parameters ?? [:])
    }
}
