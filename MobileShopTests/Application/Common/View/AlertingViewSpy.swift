//
//  AlertingViewSpy.swift
//  MobileShopTests
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation
import MobileShop

struct RecordedAlertContent: Equatable {
    let title: String?
    let message: String?
    let actionTitles: [String]
}

class AlertingViewStub: AlertingView {
    func showAlert(title: String?, message: String?, actions: [AlertAction], onDismiss: VoidHandler?) {
        let actionTitles = actions.map(\.title)
        recordedAlertContents.append(.init(title: title, message: message, actionTitles: actionTitles))
        recordedOnDismissHandlers.append(onDismiss)
    }
    var recordedAlertContents: [RecordedAlertContent] = []
    var recordedOnDismissHandlers: [VoidHandler?] = []
}
