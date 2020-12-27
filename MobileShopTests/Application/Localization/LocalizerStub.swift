//
//  LocalizerStub.swift
//  MobileShopTests
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation
@testable import MobileShop

final class LocalizerStub: Localising {
    func localize(_ key: String) -> String {
        return key
    }

    func localize(_ key: String, _ values: CVarArg...) -> String {
        let stringValues = values.map { "\($0)"}
        return "\(key),\(stringValues.joined(separator: ","))"
    }
}
