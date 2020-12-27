//
//  FirebaseAnalyticsService.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation
import FirebaseAnalytics

protocol FirebaseAnalyticsServicing {
    func logEvent(_ event: String, parameters: [String: NSObject]?)
}

extension FirebaseAnalyticsServicing {
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

class FirebaseAnalyticsService: FirebaseAnalyticsServicing {
    func logEvent(_ event: String, parameters: [String: NSObject]?) {
        Analytics.logEvent(event, parameters: parameters)
    }
}
