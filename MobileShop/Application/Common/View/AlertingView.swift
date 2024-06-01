//
//  AlertingView.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

public protocol AlertingView {
    func showAlert(
        title: String?,
        message: String?,
        actions: [AlertAction],
        onDismiss: VoidHandler?
    )
}

public struct AlertAction {
    public let title: String
    public let style: AlertActionStyle = .default
    public let handler: VoidHandler? = nil
}
