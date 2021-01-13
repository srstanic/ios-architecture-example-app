//
//  CartController.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

// MARK: CartView & CartViewDelegate

protocol CartView: class, View, LoadableView, AlertingView {
    func setPayButtonTitle(_ title: String)
    func showCartContent(_ cartContent: CartViewContent)
}

struct CartViewContent {
    let products: [CartProductItemViewContent]
    let discounts: [CartDiscountViewContent]
    let total: CartTotalViewContent
}

struct CartProductItemViewContent {
    let title: String
    let price: String
    let quantity: String
    let discount: String?
}

struct CartDiscountViewContent {
    let title: String
    let discount: String
}

struct CartTotalViewContent {
    let title: String
    let amount: String
}

protocol CartViewDelegate: class, ViewDelegate {
    func onPaymentInitiated()
}

// MARK: CartControllerDelegate

protocol CartControllerDelegate {
    func didChooseToPay(for amount: Double)
}

// MARK: CartTracking

protocol CartTracking: SceneTracking {
    func onDidChooseToPay()
}

final class CartController: CartViewDelegate {
    struct Dependencies {
        let cartService: CartServicing
        let localizer: Localising
        let tracker: CartTracking
    }

    init(dependencies: Dependencies, delegate: CartControllerDelegate) {
        self.dependencies = dependencies
        self.delegate = delegate
    }
    private let dependencies: Dependencies
    private let delegate: CartControllerDelegate

    weak var view: CartView?

    // MARK: CartViewDelegate

    func onViewDidLoad() {
        view?.setTitle(dependencies.localizer.localize("CART_SCENE_TITLE"))
        view?.setPayButtonTitle(dependencies.localizer.localize("CART_SCENE_PAY_BUTTON_TITLE"))

        loadAndShowCart()
    }

    private func loadAndShowCart() {
        view?.setLoadingIndicatorVisibility(isHidden: false)
        dependencies.cartService.getCart { [weak self] cartResult in
            guard let self = self else {
                return
            }

            self.view?.setLoadingIndicatorVisibility(isHidden: true)
            switch cartResult {
                case .success(let cart):
                    self.showCartContent(for: cart)
                case .failure(_):
                    self.showErrorAlert() {
                        self.loadAndShowCart()
                    }
            }
        }
    }
    private var cartTotal: Double = 0

    private func showCartContent(for cart: Cart) {
        let cartTotal = cart.calculateTotalPriceAmount()
        self.cartTotal = cartTotal // so it can be passed to the payment scene

        let cartViewContent = CartViewContent.map(
            from: cart,
            with: cartTotal,
            localizer: dependencies.localizer
        )
        view?.showCartContent(cartViewContent)
    }

    private func showErrorAlert(with completion: @escaping VoidHandler) {
        let title = dependencies.localizer.localize("CART_SCENE_ERROR_TITLE")
        let message = dependencies.localizer.localize("CART_SCENE_ERROR_MESSAGE")
        let buttonTitle = dependencies.localizer.localize("RETRY")
        view?.showAlert(
            title: title,
            message: message,
            actions: [AlertAction(title: buttonTitle)],
            onDismiss: completion
        )
    }

    func onViewWillAppear() {}

    func onViewDidAppear() {
        dependencies.tracker.onDidVisitScene()
    }

    func onViewDidDisappear() {}

    func onPaymentInitiated() {
        dependencies.tracker.onDidChooseToPay()
        delegate.didChooseToPay(for: cartTotal)
    }
}

extension CartViewContent {
    fileprivate static func map(
        from cart: Cart,
        with total: Double,
        localizer: Localising
    ) -> Self {
        var discountsByProductIdMap: [String: Int] = [:]
        let productDiscounts = cart.discounts.filter { $0.productId != nil }
        for discount in productDiscounts {
            discountsByProductIdMap[discount.productId!] = discount.amountAsPercentage
        }

        let productContentItems: [CartProductItemViewContent] = cart.products
            .map { productCartItem in
                let discountString: String? = {
                    let discount = discountsByProductIdMap[productCartItem.product.id]
                    return discount != nil ? localizer.localize("CART_SCENE_DISCOUNT_VALUE", "\(discount!)") : nil
                }()
                let priceString = localizer.localize("PRICE_AMOUNT", "\(productCartItem.product.price)")
                let quantityString = localizer.localize("CART_SCENE_QUANTITY_VALUE", "\(productCartItem.quantity)")
                return .init(
                    title: productCartItem.product.title,
                    price: priceString,
                    quantity: quantityString,
                    discount: discountString
                )
            }

        let discountContentItems: [CartDiscountViewContent] = cart.discounts
            .filter { $0.productId == nil }
            .map {
                let discountValue = $0.amountAsPercentage
                let discountString = localizer.localize("CART_SCENE_DISCOUNT_VALUE", "\(discountValue)")
                return .init(title: $0.title, discount: discountString)
            }

        let totalCotentItem = CartTotalViewContent(
            title: localizer.localize("CART_SCENE_TOTAL_LABEL"),
            amount: localizer.localize("PRICE_AMOUNT", String(format: "%.2f", total))
        )

        let cartViewContent = CartViewContent(
            products: productContentItems,
            discounts: discountContentItems,
            total: totalCotentItem
        )
        return cartViewContent
    }
}