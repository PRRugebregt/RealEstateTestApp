//
//  HouseManagerTests.swift
//  RealEstateDTTTests
//
//  Created by Patrick Rugebregt on 02/03/2022.
//

import XCTest
@testable import RealEstateDTT

class HouseManagerTests: XCTestCase {

    var sut: HouseManager?
    
    override func setUpWithError() throws {
        try! super.setUpWithError()
        sut = HouseManager(
    }

    override func tearDownWithError() throws {
        sut = nil
        try! super.tearDownWithError()
    }

}
