//
//  UIControl+Extensions.swift
//  MobileShopTests
//
//  Created by Srđan Stanić on 13.03.2023.
//

import UIKit

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
