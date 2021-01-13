//
//  CartViewController.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import UIKit

class CartViewController: LoadableTableViewController, CartView {

    // MARK: Delegate

    var delegate: CartViewDelegate?

    // MARK: CartView

    func setTitle(_ title: String) {
        self.title = title
    }

    func setPayButtonTitle(_ title: String) {
        setupPayButton(titled: title)
    }

    private func setupPayButton(titled title: String) {
        navigationItem.rightBarButtonItem = .init(
            title: title,
            style: .done,
            target: self,
            action: #selector(onPayButtonTapped)
        )
    }

    @objc private func onPayButtonTapped() {
        delegate?.onPaymentInitiated()
    }

    func showCartContent(_ cartContent: CartViewContent) {
        self.dataSource = buildDataSource(for: cartContent)
        tableView.reloadData()
    }
    private var dataSource = TableViewDataSource(sections: [])

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        delegate?.onViewDidLoad()
    }

    private func setupTableView() {
        tableView.register(CartItemTableViewCell.self, forCellReuseIdentifier: cartItemCellReuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }
    private let cartItemCellReuseIdentifier = CartItemTableViewCell.reuseIdentifier

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.onViewDidAppear()
    }

    // MARK: UITableViewDataSource

    private func buildDataSource(for cartContent: CartViewContent) -> TableViewDataSource {
        let productItems = cartContent.products
        var sections: [TableViewSection] = [
            TableViewSection(
                models: productItems,
                configureCell: { (cell: CartItemTableViewCell, productItem: CartProductItemViewContent) in
                    cell.cartItemView.setDescription(productItem.title)
                    cell.cartItemView.setPrimaryValue(productItem.price)
                    cell.cartItemView.setSecondaryValue(productItem.quantity)
                    cell.cartItemView.setTertiaryValue(productItem.discount)
                    cell.cartItemView.setSeparatorColor(.separator)
                }
            )
        ]

        let cartDiscounts = cartContent.discounts
        if !cartDiscounts.isEmpty {
            sections.append(
                TableViewSection(
                    models: cartDiscounts,
                    configureCell: { (cell: CartItemTableViewCell, cartDiscount: CartDiscountViewContent) in
                        cell.cartItemView.setDescription(cartDiscount.title)
                        cell.cartItemView.setPrimaryValue(cartDiscount.discount)
                        cell.cartItemView.setSeparatorColor(.black)
                    }
                )
            )
        }

        let cartTotal = cartContent.total
        sections.append(
            TableViewSection(
                models: [cartTotal],
                configureCell: { (cell: CartItemTableViewCell, cartTotal: CartTotalViewContent) in
                    cell.cartItemView.setDescription(cartTotal.title)
                    cell.cartItemView.setPrimaryValue(cartTotal.amount)
                    cell.cartItemView.setSeparatorColor(.clear)
                }
            )
        )

        return TableViewDataSource(sections: sections)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.sections[section].numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cartItemCellReuseIdentifier, for: indexPath)
        cell.selectionStyle = .none
        dataSource.sections[indexPath.section].configure(cell, atRow: indexPath.row)
        return cell
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

fileprivate struct TableViewDataSource {
    let sections: [TableViewSection]
}

fileprivate struct TableViewSection {
    init<CellType: UITableViewCell, RowModelType>(
        models: [RowModelType],
        configureCell: @escaping (CellType, RowModelType) -> Void
    ) {
        self.models = models
        self.configureCell = { anyCell, anyModel in
            guard
                let typedCell = anyCell as? CellType,
                let typedModel = anyModel as? RowModelType
            else {
                return
            }
            configureCell(typedCell, typedModel)
        }

    }
    private var models: [Any]
    private var configureCell: (UITableViewCell, Any) -> Void

    var numberOfRows: Int {
        return models.count
    }

    func configure(_ cell: UITableViewCell, atRow row: Int) {
        let model = models[row]
        configureCell(cell, model)
    }
}
