//
//  FacebookAnalyticsService.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation
import FBSDKCoreKit

public protocol FacebookAnalyticsService {
    func logEvent(_ event: String, parameters: [String: NSObject]?)
}

extension FacebookAnalyticsService {
    func logPurchase(withAmount amount: Double) {
        logEvent("purchase", parameters: ["amount": NSNumber(value: amount)])
    }
}

final class FacebookAppEventsAdapter: FacebookAnalyticsService {
    func logEvent(_ event: String, parameters: [String : NSObject]?) {
        AppEvents.logEvent(.init(rawValue: event), parameters: parameters ?? [:])
    }
}
