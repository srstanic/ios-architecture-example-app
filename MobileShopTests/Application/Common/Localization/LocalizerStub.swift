//
//  LocalizerStub.swift
//  MobileShopTests
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation
@testable import MobileShop

final class LocalizerStub: Localizing {
    func localize(_ key: String) -> String {
        localized(key)
    }

    func localize(_ key: String, _ values: CVarArg...) -> String {
        localized(key, values)
    }
}

func localized(_ string: String) -> String {
    return "LOCALIZED_\(string)"
}

func localized(_ key: String, _ values: CVarArg...) -> String {
    let stringValues = values.map { "\($0)"}
    return "\(localized(key)),\(stringValues.joined(separator: ","))"
}
