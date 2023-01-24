//
//  Coordinating.swift
//  MobileShop
//
//  Created by Srđan Stanić on 24.01.2023.
//

import Foundation

protocol Coordinating<Destination> {
    associatedtype Destination
    func transition(to destination: Destination)
}
