//
//  NullPaymentService.swift
//  MobileShop
//
//  Created by Srđan Stanić on 13.03.2023.
//

import Foundation

final class NullPaymentService: PaymentService {
    func processPayment(for amount: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        // If this was a real app, there would be some transaction processing logic here
        // but since this is an example app, for the simplicity sake, we'll assume the
        // transaction went through and complete with a .success result.
        completion(.success(()))
    }
}
