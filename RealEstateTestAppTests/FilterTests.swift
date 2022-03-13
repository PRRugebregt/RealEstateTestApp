//
//  FilterTests.swift
//  RealEstateTestAppTests
//
//  Created by Patrick Rugebregt on 23/02/2022.
//

import Foundation
@testable import RealEstateTestApp
import XCTest

class FilterTests: XCTestCase {
    
    var sut: Filter?
    
    override func setUpWithError() throws {
        try! super.setUpWithError()
        sut = Filter()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try! super.tearDownWithError()
    }
    
    func testFilter() {
        sut?.originalHousesList = [
            House(id: 0, imageURL: "", descriptionString: "", zip: "", city: "A", price: 1000, bedrooms: 1, bathrooms: 2, size: 100, latitude: 50, longitude: 50),
            House(id: 0, imageURL: "", descriptionString: "", zip: "", city: "A", price: 1000, bedrooms: 1, bathrooms: 2, size: 100, latitude: 50, longitude: 50),
            House(id: 1, imageURL: "", descriptionString: "", zip: "", city: "B", price: 2000, bedrooms: 2, bathrooms: 1, size: 100, latitude: 50, longitude: 50)]
        let first = sut?.filter(with: "A")
        XCTAssert(first!.count == 2)
        let second = sut?.filter(with: "B")
        XCTAssert(second!.count == 1)
        let third = sut?.filter(with: "C")
        XCTAssert(third!.count == 0)
    }
    
}
