//
//  FirebaseAnalyticsServiceStub.swift
//  MobileShopTests
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation
@testable import MobileShop

struct FirebaseRecordedEvent: Equatable {
    let event: String
    let parameters: [String: NSObject]?

    static func sceneVisitEvent(_ sceneTitle: String) -> Self {
        .init(event: "scene_visit", parameters: ["title": sceneTitle as NSObject])
    }

    static func userActionEvent(_ actionTitle: String) -> Self {
        .init(event: "user_action", parameters: ["title": actionTitle as NSObject])
    }

    static func purchaseEvent(_ amount: Double) -> Self {
        .init(event: "purchase", parameters: ["amount": NSNumber(value: amount)])
    }
}

class FirebaseAnalyticsServiceStub: FirebaseAnalyticsServicing {
    func logEvent(_ event: String, parameters: [String: NSObject]?) {
        recordedEvents.append(FirebaseRecordedEvent(event: event, parameters: parameters))
    }
    var recordedEvents: [FirebaseRecordedEvent] = []


    func containsRecordedEvent(_ event: FirebaseRecordedEvent) -> Bool {
        recordedEvents.contains(event)
    }
}
