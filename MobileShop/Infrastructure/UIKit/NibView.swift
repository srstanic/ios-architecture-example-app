//
//  NibView.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import UIKit

/// Extend `NibView` to create a reusable view in a XIB file.
/// The contents of the view are designed in a XIB file.
/// The `NibView` class is responsible for loading the
/// contents of the XIB file and setting it as its subview.
/// File's Owner in the XIB file needs to be set to the
/// view class extending the `NibView`. Any outlets defined
/// in that class need to be connected to the File's Owner.
class NibView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadContentViewFromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadContentViewFromNib()
    }
}

private extension NibView {
    func loadContentViewFromNib() {
        backgroundColor = UIColor.clear
        let contentView = loadNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }
}

extension UIView {
    /// Loads UIView from a XIB file with the same name.
    fileprivate func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}
