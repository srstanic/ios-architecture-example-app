//
//  CartItemTableViewCell.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import UIKit

class CartItemTableViewCell: UITableViewCell {
    lazy var cartItemView: CartItemView = {
        return CartItemView(frame: .zero).withAutoLayout()
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cartItemView)
        cartItemView.layoutWithEdgesToSuperview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
