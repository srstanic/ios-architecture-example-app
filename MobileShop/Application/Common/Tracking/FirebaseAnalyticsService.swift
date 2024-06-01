//
//  FirebaseAnalyticsService.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation
import FirebaseAnalytics

public protocol FirebaseAnalyticsService {
    func logEvent(_ event: String, parameters: [String: NSObject]?)
}

extension FirebaseAnalyticsService {
    func logSceneVisit(titled sceneTitle: String) {
        logEvent("scene_visit", parameters: ["title": sceneTitle as NSObject])
    }

    func logUserAction(titled elementTitle: String) {
        logEvent("user_action", parameters: ["title": elementTitle as NSObject])
    }

    func logPurchase(withAmount amount: Double) {
        logEvent("purchase", parameters: ["amount": NSNumber(value: amount)])
    }
}

final class FirebaseAnalyticsAdapter: FirebaseAnalyticsService {
    func logEvent(_ event: String, parameters: [String: NSObject]?) {
        Analytics.logEvent(event, parameters: parameters)
    }
}
