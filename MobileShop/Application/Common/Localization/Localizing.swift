//
//  Localizing.swift
//  MobileShop
//
//  Created by Srđan Stanić on 10.03.2023.
//

import Foundation

protocol Localizing {
    func localize(_ key: String) -> String
    func localize(_ key: String, _ values: CVarArg... ) -> String
}
