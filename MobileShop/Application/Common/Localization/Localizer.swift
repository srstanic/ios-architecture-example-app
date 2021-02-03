//
//  Localizer.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

protocol Localizing {
    func localize(_ key: String) -> String
    func localize(_ key: String, _ values: CVarArg... ) -> String
}

final class Localizer: Localizing {
    func localize(_ key: String) -> String {
        NSLocalizedString(key, tableName: nil, bundle: defaultBundle, value: key, comment: "")
    }

    func localize(_ key: String, _ values: CVarArg...) -> String {
        return String(format: localize(key), arguments: values)
    }

    private class BundleHelper {}
    private let defaultBundle = Bundle(for: BundleHelper.self)
}
