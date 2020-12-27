//
//  CartItemView.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import UIKit

class CartItemView: NibView {
    func setDescription(_ text: String?) {
        descriptionLabel.text = text
    }

    func setPrimaryValue(_ text: String?) {
        set(value: text, to: primaryValueLabel)
    }

    func setSecondaryValue(_ text: String?) {
        set(value: text, to: secondaryValueLabel)
    }

    func setTertiaryValue(_ text: String?) {
        set(value: text, to: tertiaryValueLabel)
    }

    private func set(value: String?, to label: UILabel) {
        label.text = value
        label.isHidden = value == nil
    }

    func setSeparatorColor(_ color: UIColor) {
        separatorView.backgroundColor = color
    }

    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var primaryValueLabel: UILabel!
    @IBOutlet private weak var secondaryValueLabel: UILabel!
    @IBOutlet private weak var tertiaryValueLabel: UILabel!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var separatorViewHeight: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        descriptionLabel.text = nil
        setPrimaryValue(nil)
        setSecondaryValue(nil)
        setTertiaryValue(nil)
        separatorViewHeight.constant = UIScreen.onePixel
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
