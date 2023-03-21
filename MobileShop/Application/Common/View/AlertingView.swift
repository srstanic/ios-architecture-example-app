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
    let title: String
    let style: AlertActionStyle = .default
    let handler: VoidHandler? = nil
}
