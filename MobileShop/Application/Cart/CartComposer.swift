//
//  CartComposer.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import UIKit

final class CartComposer {
    func composeCartScene(with outputs: CartSceneOutputs) -> UIViewController {
        let cartViewController: CartViewController = .initFromStoryboard()

        let mobileShopApiClient = MobileShopApiClient.development()
        let cartService = CartRemoteService(apiClient: mobileShopApiClient)

        let localizer = Localizer()

        let firebaseAnalyticsService = FirebaseAnalyticsService()
        let cartTracker = CartTracker(firebaseAnalyticsService: firebaseAnalyticsService)

        let presenterDependencies = CartPresenter.Dependencies(
            cartService: cartService,
            localizer: localizer,
            tracker: cartTracker
        )

        let presenter = CartPresenter(dependencies: presenterDependencies, outputs: outputs)

        cartViewController.outputs = presenter
        presenter.view = cartViewController

        return cartViewController
    }
}
