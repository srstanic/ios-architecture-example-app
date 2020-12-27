//
//  AlertingView+UIViewController.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import UIKit

extension AlertingView where Self: UIViewController {
    func showAlert(
        title: String?,
        message: String?,
        actions: [AlertAction],
        onDismiss: VoidHandler?
    ) {
        let alertController = UIAlertController.createDialog(
            title: title,
            message: message,
            actions: actions,
            onDismiss: onDismiss
        )
        self.present(alertController, animated: true)
    }
}
