//
//  CartBuilder.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import UIKit

final class CartBuilder {
    func buildCartScene(with delegate: CartControllerDelegate) -> UIViewController {
        let cartViewController: CartViewController = .initFromStoryboard()

        let mobileShopApiClient = MobileShopApiClient.development()
        let cartService = CartRemoteService(apiClient: mobileShopApiClient)

        let localizer = Localizer()

        let firebaseAnalyticsService = FirebaseAnalyticsService()
        let cartTracker = CartTracker(firebaseAnalyticsService: firebaseAnalyticsService)

        let controllerDependencies = CartController.Dependencies(
            cartService: cartService,
            localizer: localizer,
            tracker: cartTracker
        )

        let controller = CartController(dependencies: controllerDependencies, delegate: delegate)

        cartViewController.delegate = controller
        controller.view = cartViewController

        return cartViewController
    }
}
