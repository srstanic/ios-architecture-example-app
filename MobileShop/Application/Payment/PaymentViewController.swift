//
//  PaymentViewController.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import UIKit

class PaymentViewController: UIViewController, PaymentView {

    // MARK: Delegate

    var delegate: PaymentViewDelegate?

    // MARK: PaymentView

    func setAmountTitle(_ amountTitle: String) {
        amountTitleLabel.text = amountTitle
    }
    @IBOutlet private weak var amountTitleLabel: UILabel!

    func setChargeNote(_ chargeNote: String) {
        chargeNoteLabel.text = chargeNote
    }
    @IBOutlet private weak var chargeNoteLabel: UILabel!

    func setConfirmPurchaseButtonTitle(_ confirmPurchaseButtonTitle: String){
        confirmPurchaseButton.setTitle(confirmPurchaseButtonTitle, for: .normal)
    }
    @IBOutlet private weak var confirmPurchaseButton: UIButton!

    func showAmount(_ amount: String) {
        amountValueLabel.text = amount
    }
    @IBOutlet private weak var amountValueLabel: UILabel!

    // MARK: Lifecycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.onViewDidAppear()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.onViewDidLoad()
    }

    // MARK: Actions

    @IBAction func confirmPurchase(_ sender: Any) {
        delegate?.onPurchaseConfirmed()
    }
}
