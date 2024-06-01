//
//  LoadableTableViewController.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import UIKit

public class LoadableTableViewController: UITableViewController, LoadableView {

    // MARK: LoadableView

    public func setLoadingIndicatorVisibility(isHidden: Bool) {
        if isHidden {
            tableView.tableFooterView = UIView()
            loadingIndicatorView.stopAnimating()
        } else {
            loadingIndicatorView.startAnimating()
            tableView.tableFooterView = loadingIndicatorView
        }
    }

    private lazy var loadingIndicatorView: TableFooterLoadingIndicatorView = {
        return TableFooterLoadingIndicatorView()
    }()
}

fileprivate class TableFooterLoadingIndicatorView: UIView {
    convenience init() {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        self.init(frame: frame)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        addSubview(loadingIndicator)
        loadingIndicator.frame = frame

        isUserInteractionEnabled = false
    }
    private let loadingIndicator = UIActivityIndicatorView()

    func startAnimating() {
        loadingIndicator.startAnimating()
    }

    func stopAnimating() {
        loadingIndicator.stopAnimating()
    }
}
