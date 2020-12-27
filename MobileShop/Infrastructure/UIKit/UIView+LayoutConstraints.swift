//
//  UIView+LayoutConstraints.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import UIKit

extension UIView {
    func withAutoLayout() -> Self {
      translatesAutoresizingMaskIntoConstraints = false
      return self
    }

    func layoutWithEdgesToSuperview() {
        guard let theSuperview = superview else {
            return
        }
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: theSuperview.topAnchor, constant: 0),
            leadingAnchor.constraint(equalTo: theSuperview.leadingAnchor, constant: 0),
            bottomAnchor.constraint(equalTo: theSuperview.bottomAnchor, constant: 0),
            trailingAnchor.constraint(equalTo: theSuperview.trailingAnchor, constant: 0)
        ])
    }
}
