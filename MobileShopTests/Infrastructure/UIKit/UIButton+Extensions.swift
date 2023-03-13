//
//  UIButton+Extensions.swift
//  MobileShopTests
//
//  Created by Srđan Stanić on 13.03.2023.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
