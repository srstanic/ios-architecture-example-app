//
//  CartPresenter.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

// MARK: CartView & CartViewOutputs

public protocol CartView: TitledView, LoadableView, AlertingView {
    func setPayButtonTitle(_ title: String)
    func showCartContent(_ cartContent: CartViewContent)
}

public struct CartViewContent {
    public let products: [CartProductItemViewContent]
    public let discounts: [CartDiscountViewContent]
    public let total: CartTotalViewContent
}

public struct CartProductItemViewContent {
    public let title: String
    public let price: String
    public let quantity: String
    public let discount: String?
}

public struct CartDiscountViewContent {
    public let title: String
    public let discount: String
}

public struct CartTotalViewContent {
    public let title: String
    public let amount: String
}

public protocol CartViewOutputs: ViewOutputs {
    func onPaymentInitiated()
}

// MARK: CartSceneOutputs

public protocol CartSceneOutputs {
    func onDidChooseToPay(for amount: Double)
}

// MARK: CartLoading

public typealias CartResultHandler = (Result<Cart, Error>) -> Void

public protocol CartLoading {
    func loadCart(completion: @escaping CartResultHandler)
}

public enum CartLoadingError: Error {
    case failedToLoadCartData
}

// MARK: CartPresenter

public final class CartPresenter: CartViewOutputs {
    public struct Dependencies {
        let cartLoader: CartLoading
        let localizer: Localizing

        public init(cartLoader: any CartLoading, localizer: any Localizing) {
            self.cartLoader = cartLoader
            self.localizer = localizer
        }
    }

    public init(dependencies: Dependencies, outputs: CartSceneOutputs) {
        self.dependencies = dependencies
        self.outputs = outputs
    }
    private let dependencies: Dependencies
    private let outputs: CartSceneOutputs

    public var view: CartView?

    // MARK: CartViewOutputs

    public func onViewDidLoad() {
        view?.setTitle(dependencies.localizer.localize(.title))
        view?.setPayButtonTitle(dependencies.localizer.localize(.payButtonTitle))

        loadAndShowCart()
    }

    private func loadAndShowCart() {
        view?.setLoadingIndicatorVisibility(isHidden: false)
        dependencies.cartLoader.loadCart { [weak self] cartResult in
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
        let cartTotal = CartRules.calculateTotalPriceAmount(for: cart)
        self.cartTotal = cartTotal // so it can be passed to the payment scene

        let cartViewContent = CartViewContent.map(
            from: cart,
            with: cartTotal,
            localizer: dependencies.localizer
        )
        view?.showCartContent(cartViewContent)
    }

    private func showErrorAlert(with completion: @escaping VoidHandler) {
        let title = dependencies.localizer.localize(.errorTitle)
        let message = dependencies.localizer.localize(.errorMessage)
        let buttonTitle = dependencies.localizer.localize(.errorActionTitle)
        view?.showAlert(
            title: title,
            message: message,
            actions: [AlertAction(title: buttonTitle)],
            onDismiss: completion
        )
    }

    public func onViewWillAppear() {}

    public func onViewDidAppear() {}

    public func onViewDidDisappear() {}

    public func onPaymentInitiated() {
        outputs.onDidChooseToPay(for: cartTotal)
    }
}

extension CartViewContent {
    fileprivate static func map(
        from cart: Cart,
        with total: Double,
        localizer: Localizing
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
                    return discount != nil ? localizer.localize(.discountValue, "\(discount!)") : nil
                }()
                let priceString = localizer.localize(.priceAmount, "\(productCartItem.product.price)")
                let quantityString = localizer.localize(.quantityValue, "\(productCartItem.quantity)")
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
                let discountString = localizer.localize(.discountValue, "\(discountValue)")
                return .init(title: $0.title, discount: discountString)
            }

        let totalCotentItem = CartTotalViewContent(
            title: localizer.localize(.totalLabel),
            amount: localizer.localize(.priceAmount, String(format: "%.2f", total))
        )

        let cartViewContent = CartViewContent(
            products: productContentItems,
            discounts: discountContentItems,
            total: totalCotentItem
        )
        return cartViewContent
    }
}

private extension String {
    static let title = "CART_SCENE_TITLE"
    static let payButtonTitle = "CART_SCENE_PAY_BUTTON_TITLE"
    static let quantityValue = "CART_SCENE_QUANTITY_VALUE"
    static let discountValue = "CART_SCENE_DISCOUNT_VALUE"
    static let totalLabel = "CART_SCENE_TOTAL_LABEL"
    static let errorTitle = "CART_SCENE_ERROR_TITLE"
    static let errorMessage = "CART_SCENE_ERROR_MESSAGE"
    static let errorActionTitle = "CART_SCENE_ERROR_ACTION_TITLE"
    static let priceAmount = "CART_SCENE_PRICE_AMOUNT"
}
