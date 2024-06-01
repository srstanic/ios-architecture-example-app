//
//  ViewOutputs.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

public protocol ViewOutputs {
    func onViewDidLoad()
    func onViewWillAppear()
    func onViewDidAppear()
    func onViewDidDisappear()
}
