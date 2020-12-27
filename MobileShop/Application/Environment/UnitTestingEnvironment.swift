//
//  UnitTestingEnvironment.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

func isUnitTestingEnvironment() -> Bool {
    return NSClassFromString("XCTestCase") != nil
}
