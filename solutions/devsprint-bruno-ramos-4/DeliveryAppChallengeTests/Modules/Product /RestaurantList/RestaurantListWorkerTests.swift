//
//  RestaurantListWorkerTests.swift
//  DeliveryAppChallengeTests
//
//  Created by pedro tres on 14/06/22.
//

import Foundation
import XCTest
@testable import DeliveryAppChallenge

final class RestaurantListWorkerTests: XCTestCase {
    
    private let networkSpy = NetworkManagerProtocolSpy()
    
    private lazy var sut = RestaurantListWorker(network: networkSpy)
    private typealias RequestResult = Result<[RestaurantResponse], Error>
    
    func test_fetchRestaurantList_X() {
        var expectedResult: Result<[Restaurant], Error>?
        networkSpy.requestToBeReturned = RequestResult.success([])
        
        sut.fetchRestaurantList {
            expectedResult = $0
        }
        XCTAssertNotNil(expectedResult)
        switch expectedResult {
        case .success(let restaurantList):
            XCTAssertTrue(restaurantList.isEmpty)
        default:
            XCTFail("result should be success")
        }
    }
    
    func test_fetchRestaurantList_Y() {
        var expectedResult: Result<[Restaurant], Error>?
        networkSpy.requestToBeReturned = RequestResult.failure(ErrorDummy())
        
        sut.fetchRestaurantList {
            expectedResult = $0
        }
        XCTAssertNotNil(expectedResult)
        switch expectedResult {
        case .failure(let error):
            XCTAssertNotNil(error as? ErrorDummy)
        default:
            XCTFail("result should be failure")
        }
    }
    
    func test_fetchRestaurantList_Z() {
        var expectedResult: Result<[Restaurant], Error>?
        networkSpy.requestToBeReturned = RequestResult.success([
            RestaurantResponse.fixture(category: "devpass")
        ])
        
        sut.fetchRestaurantList {
            expectedResult = $0
        }
        XCTAssertNotNil(expectedResult)
        switch expectedResult {
        case .success(let restaurantList):
            XCTAssertFalse(restaurantList.isEmpty)
            XCTAssertEqual(restaurantList.first?.category, "")
        default:
            XCTFail("result should be success")
        }
    }
}

extension RestaurantResponse {
    static func fixture(name: String = "",
                        category: String = "",
                        deliveryTime: RestaurantResponse.DeliveryTime = .fixture()) -> RestaurantResponse {
        
        .init(name: name, category: category, deliveryTime: deliveryTime)
    }
}


extension RestaurantResponse.DeliveryTime {
    static func fixture(min: Int = 0, max: Int = 0 ) -> RestaurantResponse.DeliveryTime {
        .init(min: min, max: max)
    }
}
