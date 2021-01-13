//
//  AlertingView.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

protocol AlertingView {
    func showAlert(
        title: String?,
        message: String?,
        actions: [AlertAction],
        onDismiss: VoidHandler?
    )
}

struct AlertAction {
    var title: String
    var style: AlertActionStyle = .default
    var handler: VoidHandler? = nil
}
