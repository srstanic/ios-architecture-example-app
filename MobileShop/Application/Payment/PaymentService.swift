//
//  PaymentService.swift
//  MobileShop
//
//  Created by Srđan Stanić on 13.03.2023.
//

import Foundation

public protocol PaymentService {
    func processPayment(for amount: Double, completion: @escaping (Result<Void, Error>) -> Void)
}
