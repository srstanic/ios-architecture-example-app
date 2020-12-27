//
//  LocalizerTests.swift
//  MobileShopTests
//
//  Created by Srđan Stanić on 09/12/2020.
//

import XCTest
@testable import MobileShop

class LocalizerTests: XCTestCase {
    func testString() throws {
        let sut = Localizer()
        XCTAssertEqual(sut.localize("TEST_STRING"), "Test String")
    }

    func testStringWithArguments() throws {
        let sut = Localizer()
        XCTAssertEqual(sut.localize("TEST_STRING_WITH_ARGUMENTS", "Arguments"), "Test String With Arguments")
    }
}
