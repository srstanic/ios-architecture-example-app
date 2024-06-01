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

    public func loadCart(completion: @escaping CartResultHandler) {
        Task {
            do {
                let remoteCart = try await cartStore.getCart()
                let productIds = remoteCart.productItems.map(\.productId)
                async let remoteProducts = productsStore.getProducts(withIds: productIds)
                async let remoteDiscounts = discountsStore.getDiscounts(withIds: remoteCart.discountIds)
                let cart = Cart.map(from: remoteCart, try await remoteProducts, try await remoteDiscounts)
                completion(.success(cart))
            } catch {
                completion(.failure(CartLoadingError.failedToLoadCartData))
            }

        }
    }
}

private extension Cart {
    static func map(
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

private extension Product {
    static func map(from remoteStoreProduct: RemoteStoreProduct) -> Self {
        return .init(id: remoteStoreProduct.id, title: remoteStoreProduct.title, price: remoteStoreProduct.price)
    }
}

private extension Discount {
    static func map(from remoteStoreDiscount: RemoteStoreDiscount) -> Self {
        return .init(
            id: remoteStoreDiscount.id,
            title: remoteStoreDiscount.title,
            amountAsPercentage: remoteStoreDiscount.amountAsPercentage,
            productId: remoteStoreDiscount.productId
        )
    }
}

private extension CartRemoteStore {
    func getCart() async throws -> RemoteStoreCart {
        try await withCheckedThrowingContinuation { continuation in
            getCart { result in
                continuation.resume(with: result)
            }
        }
    }
}

private extension ProductsRemoteStore {
    func getProducts(withIds productIds: [String]) async throws -> [RemoteStoreProduct] {
        try await withCheckedThrowingContinuation { continuation in
            getProducts(withIds: productIds) { result in
                continuation.resume(with: result)
            }
        }
    }
}


private extension DiscountsRemoteStore {
    func getDiscounts(withIds discountIds: [String]) async throws -> [RemoteStoreDiscount] {
        try await withCheckedThrowingContinuation({ continuation in
            getDiscounts(withIds: discountIds) { result in
                continuation.resume(with: result)
            }
        })
    }
}
