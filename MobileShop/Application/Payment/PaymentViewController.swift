//
//  PaymentViewController.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import UIKit

class PaymentViewController: UIViewController, PaymentView {

    // MARK: Outputs

    var outputs: PaymentViewOutputs?

    // MARK: PaymentView

    func setAmountTitle(_ amountTitle: String) {
        amountTitleLabel.text = amountTitle
    }
    @IBOutlet private(set) weak var amountTitleLabel: UILabel!

    func setChargeNote(_ chargeNote: String) {
        chargeNoteLabel.text = chargeNote
    }
    @IBOutlet private(set) weak var chargeNoteLabel: UILabel!

    func setConfirmPurchaseButtonTitle(_ confirmPurchaseButtonTitle: String){
        confirmPurchaseButton.setTitle(confirmPurchaseButtonTitle, for: .normal)
    }
    @IBOutlet private(set) weak var confirmPurchaseButton: UIButton!

    func showAmount(_ amount: String) {
        amountValueLabel.text = amount
    }
    @IBOutlet private(set) weak var amountValueLabel: UILabel!

    // MARK: Lifecycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        outputs?.onViewDidAppear()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        outputs?.onViewDidLoad()
    }

    // MARK: Actions

    @IBAction private func confirmPurchase() {
        outputs?.onPurchaseConfirmed()
    }
}
