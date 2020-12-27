//
//  ViewDelegate.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

protocol ViewDelegate {
    func onViewDidLoad()
    func onViewWillAppear()
    func onViewDidAppear()
    func onViewDidDisappear()
}
