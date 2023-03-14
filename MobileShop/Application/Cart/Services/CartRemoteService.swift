//
//  CartRemoteService.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

final class CartRemoteService: CartLoading {
    init(apiClient: MobileShopAPIClient) {
        cartStore = CartRemoteStore(apiClient: apiClient)
        productsStore = ProductsRemoteStore(apiClient: apiClient)
        discountsStore = DiscountsRemoteStore(apiClient: apiClient)
    }
    private let cartStore: CartRemoteStore
    private let productsStore: ProductsRemoteStore
    private let discountsStore: DiscountsRemoteStore

    func loadCart(completion: @escaping CartResultHandler) {
        let completionOnMainThread: CartResultHandler = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        cartStore.getCart { [weak self] cartResult in
            switch cartResult {
                case .success(let remoteStoreCart):
                    self?.getProductsAndDiscounts(for: remoteStoreCart, completion: completionOnMainThread)
                case .failure(_):
                    // for simplicity just return a generic service error
                    completionOnMainThread(.failure(CartLoadingError.failedToLoadCartData))
            }
        }
    }

    private func getProductsAndDiscounts(
        for remoteStoreCart: RemoteStoreCart,
        completion: @escaping CartResultHandler
    ) {
        let productIds = remoteStoreCart.productItems.map(\.productId)
        productsStore.getProducts(withIds: productIds) { [weak self] productsResult in
            switch productsResult {
                case .success(let remoteStoreProducts):
                    self?.discountsStore.getDiscounts(withIds: remoteStoreCart.discountIds) { discountsResult in
                        switch discountsResult {
                            case .success(let remoteStoreDiscounts):
                                let cart = Cart.map(from: remoteStoreCart, remoteStoreProducts, remoteStoreDiscounts)
                                completion(.success(cart))
                            case .failure(_):
                                // for simplicity just return a generic service error
                                completion(.failure(CartLoadingError.failedToLoadCartData))
                        }
                    }
                case .failure(_):
                    // for simplicity just return a generic service error
                    completion(.failure(CartLoadingError.failedToLoadCartData))
            }
        }
    }
}

extension Cart {
    fileprivate static func map(
        from remoteStoreCart: RemoteStoreCart,
        _ remoteStoreProducts: [RemoteStoreProduct],
        _ remoteStoreDiscounts: [RemoteStoreDiscount]
    ) -> Cart {
        var productQuantityByProductIdMap = [String: Int]()
        for remoteStoreProductCartItem in remoteStoreCart.productItems {
            productQuantityByProductIdMap[remoteStoreProductCartItem.productId] = remoteStoreProductCartItem.quantity
        }

        var remoteStoreProductByProductIdMap = [String: RemoteStoreProduct]()
        for remoteStoreProduct in remoteStoreProducts {
            remoteStoreProductByProductIdMap[remoteStoreProduct.id] = remoteStoreProduct
        }

        var productCartItems = [ProductCartItem]()
        for remoteStoreProductCartItem in remoteStoreCart.productItems {
            let productId = remoteStoreProductCartItem.productId
            guard
                let remoteStoreProduct = remoteStoreProductByProductIdMap[productId],
                let quantity = productQuantityByProductIdMap[productId]
            else {
                continue
            }

            let product = Product.map(from: remoteStoreProduct)
            let productCartItem = ProductCartItem(product: product, quantity: quantity)
            productCartItems.append(productCartItem)
        }

        let discounts = remoteStoreDiscounts.map(Discount.map)

        let cart = Cart(
            id: remoteStoreCart.id,
            products: productCartItems,
            discounts: discounts
        )
        return cart
    }
}

extension Product {
    fileprivate static func map(from remoteStoreProduct: RemoteStoreProduct) -> Self {
        return .init(id: remoteStoreProduct.id, title: remoteStoreProduct.title, price: remoteStoreProduct.price)
    }
}
extension Discount {
    fileprivate static func map(from remoteStoreDiscount: RemoteStoreDiscount) -> Self {
        return .init(
            id: remoteStoreDiscount.id,
            title: remoteStoreDiscount.title,
            amountAsPercentage: remoteStoreDiscount.amountAsPercentage,
            productId: remoteStoreDiscount.productId
        )
    }
}
