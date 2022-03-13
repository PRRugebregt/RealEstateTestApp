//
//  HouseManagerTests.swift
//  RealEstateTestAppTests
//
//  Created by Patrick Rugebregt on 02/03/2022.
//

import XCTest
@testable import RealEstateTestApp

class HouseManagerTests: XCTestCase {

    var sut: HouseManager?
    
    override func setUpWithError() throws {
        try! super.setUpWithError()
        let coreDataManager = CoreDataManager()
        sut = HouseManager(network: MockNetwork(), locationManager: LocationManager(), houseSaveableToDisk: coreDataManager, houseFetchableFromDisk: coreDataManager)
    }

    override func tearDownWithError() throws {
        sut = nil
        try! super.tearDownWithError()
    }

}
