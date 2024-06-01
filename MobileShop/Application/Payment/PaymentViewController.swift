//
//  PaymentViewController.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import UIKit

public class PaymentViewController: UIViewController, PaymentView {

    // MARK: Outputs

    public var outputs: PaymentViewOutputs?

    // MARK: PaymentView

    public func setAmountTitle(_ amountTitle: String) {
        amountTitleLabel.text = amountTitle
    }
    @IBOutlet private(set) weak var amountTitleLabel: UILabel!

    public func setChargeNote(_ chargeNote: String) {
        chargeNoteLabel.text = chargeNote
    }
    @IBOutlet private(set) weak var chargeNoteLabel: UILabel!

    public func setConfirmPurchaseButtonTitle(_ confirmPurchaseButtonTitle: String){
        confirmPurchaseButton.setTitle(confirmPurchaseButtonTitle, for: .normal)
    }
    @IBOutlet private(set) weak var confirmPurchaseButton: UIButton!

    public func showAmount(_ amount: String) {
        amountValueLabel.text = amount
    }
    @IBOutlet private(set) weak var amountValueLabel: UILabel!

    // MARK: Lifecycle

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        outputs?.onViewDidAppear()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        outputs?.onViewDidLoad()
    }

    // MARK: Actions

    @IBAction private func confirmPurchase() {
        outputs?.onPurchaseConfirmed()
    }
}
