//
//  FacebookAnalyticsServiceStub.swift
//  MobileShopTests
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation
@testable import MobileShop

struct FacebookRecordedEvent: Equatable {
    let event: String
    let parameters: [String: NSObject]?

    static func purchaseEvent(_ amount: Double) -> Self {
        .init(event: "purchase", parameters: ["amount": NSNumber(value: amount)])
    }
}

class FacebookAnalyticsServiceStub: FacebookAnalyticsServicing {
    func logEvent(_ event: String, parameters: [String : NSObject]?) {
        recordedEvents.append(FacebookRecordedEvent(event: event, parameters: parameters))
    }
    var recordedEvents: [FacebookRecordedEvent] = []

    func containsRecordedEvent(_ event: FacebookRecordedEvent) -> Bool {
        recordedEvents.contains(event)
    }
}
