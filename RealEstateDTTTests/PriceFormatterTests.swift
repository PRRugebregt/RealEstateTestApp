//
//  PriceFormatterTests.swift
//  RealEstateDTTTests
//
//  Created by Patrick Rugebregt on 23/02/2022.
//

import Foundation
@testable import RealEstateDTT
import XCTest

class PriceFormatterTests: XCTestCase {
    
    var sut: PriceFormatter?
    
    override func setUpWithError() throws {
        try! super.setUpWithError()
        sut = PriceFormatter()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try! super.tearDownWithError()
    }
    
    func testFormattingIsCorrect() {
        let price1 = sut?.formatPrice(1000000)
        XCTAssertNotNil(price1)
        XCTAssert(price1! == "1,000,000")
        let price2 = sut?.formatPrice(1234)
        XCTAssertNotNil(price2)
        XCTAssert(price2! == "1,234")
    }
    
}
