//
//  RealEstateTestAppTests.swift
//  RealEstateTestAppTests
//
//  Created by Patrick Rugebregt on 22/02/2022.
//

import XCTest
import UIKit
@testable import RealEstateTestApp

class NetworkTests: XCTestCase {

    var sut: NetworkFetchable?
    
    override func setUpWithError() throws {
        try! super.setUpWithError()
        sut = MockNetwork()
    }

    override func tearDownWithError() throws {
        sut = nil
        try! super.tearDownWithError()
    }

    func testFetchingFromAPI() throws {
        sut?.fetchFromApi(completionHandler: { items in
            XCTAssert(items.count == 1)
            XCTAssert(items[0].price == 1000)
        })
    }
    

}
