//
//  NSLocalizer.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

final class NSLocalizer: Localizing {
    let bundle: Bundle
    let tableName: String

    init(bundle: Bundle, tableName: String) {
        self.bundle = bundle
        self.tableName = tableName
    }

    convenience init(forType type: AnyClass, tableName: String) {
        self.init(bundle: Bundle(for: type), tableName: tableName)
    }

    func localize(_ key: String) -> String {
        NSLocalizedString(key, tableName: tableName, bundle: bundle, value: key, comment: "")
    }

    func localize(_ key: String, _ values: CVarArg...) -> String {
        return String(format: localize(key), arguments: values)
    }
}
