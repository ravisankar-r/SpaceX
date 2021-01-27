//
//  EndPointTests.swift
//  SpaceXTests
//
//  Created by Ravisankar on 25/01/21.
//

import XCTest
@testable import SpaceX

class EndPointTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDefaultEndPoint() throws {
        let endpoint = EndPoint(path: "/testPath")
        XCTAssertNotNil(endpoint.url)
        XCTAssertEqual(endpoint.url, URL(string: "https://api.spacexdata.com/testPath"))
        guard let urlRequest = endpoint.urlRequest else {
            XCTFail(" URLRequest returned nil")
            return
        }
        XCTAssertEqual(urlRequest.httpMethod, "GET")
    }
    
}

