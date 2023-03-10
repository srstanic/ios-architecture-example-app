//
//  CartComposer.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import UIKit

protocol CartComposing {
    func composeCartScene(with outputs: CartSceneOutputs) -> UIViewController
}

final class CartComposer: CartComposing {
    func composeCartScene(with outputs: CartSceneOutputs) -> UIViewController {
        let cartViewController: CartViewController = .initFromStoryboard()

        let mobileShopApiClient = MobileShopApiClient.development()
        let cartService = CartRemoteService(apiClient: mobileShopApiClient)

        let localizer = NSLocalizer(forType: CartPresenter.self, tableName: "Cart")

        let firebaseAnalyticsService = FirebaseAnalyticsService()
        let cartTracker = CartTracker(firebaseAnalyticsService: firebaseAnalyticsService)

        let presenterDependencies = CartPresenter.Dependencies(
            cartService: cartService,
            localizer: localizer,
            tracker: cartTracker
        )

        let presenter = CartPresenter(dependencies: presenterDependencies, outputs: outputs)

        cartViewController.outputs = presenter
        presenter.view = WeakReferenceProxy(cartViewController)

        return cartViewController
    }
}


extension WeakReferenceProxy: CartView where ReferenceType: CartView {
    func setPayButtonTitle(_ title: String) {
        object?.setPayButtonTitle(title)
    }

    func showCartContent(_ cartContent: CartViewContent) {
        object?.showCartContent(cartContent)
    }
}

extension WeakReferenceProxy: AlertingView where ReferenceType: AlertingView {
    func showAlert(title: String?, message: String?, actions: [AlertAction], onDismiss: VoidHandler?) {
        object?.showAlert(title: title, message: message, actions: actions, onDismiss: onDismiss)
    }
}

extension WeakReferenceProxy: TitledView where ReferenceType: TitledView {
    func setTitle(_ title: String) {
        object?.setTitle(title)
    }
}

extension WeakReferenceProxy: LoadableView where ReferenceType: LoadableView {
    func setLoadingIndicatorVisibility(isHidden: Bool) {
        object?.setLoadingIndicatorVisibility(isHidden: isHidden)
    }
}
