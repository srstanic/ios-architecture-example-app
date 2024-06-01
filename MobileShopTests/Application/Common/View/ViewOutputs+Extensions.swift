//
//  ViewOutputs+Extensions.swift
//  MobileShopTests
//
//  Created by Srđan Stanić on 13.03.2023.
//

import Foundation
import MobileShop

extension ViewOutputs {
    func appearedOnScreen() {
        onViewWillAppear()
        onViewDidAppear()
    }
}
