//
//  UIAlertController+Extensions.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import UIKit

typealias AlertActionStyle = UIAlertAction.Style

extension UIAlertController {
    static func create(
        style: UIAlertController.Style,
        title: String?,
        message: String?,
        actions: [AlertAction] = [],
        onDismiss: VoidHandler? = nil
    ) -> UIAlertController {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: style)
        let nativeActions = actions.map { (alertAction) -> UIAlertAction in
            let handler: ((UIAlertAction) -> Void)? = { _ in
                alertAction.handler?()
                onDismiss?()
            }

            return UIAlertAction(
                title: alertAction.title,
                style: alertAction.style,
                handler: handler
            )
        }
        for nativeAction in nativeActions {
            alertViewController.addAction(nativeAction)
        }
        return alertViewController
    }

    static func createDialog(
        title: String?,
        message: String?,
        actions: [AlertAction],
        onDismiss: VoidHandler? = nil
    ) -> UIAlertController {
        return create(style: .alert, title: title, message: message, actions: actions, onDismiss: onDismiss)
    }
}
