//
//  APIServiceTests.swift
//  SpaceXTests
//
//  Created by Ravisankar on 25/01/21.
//

import Foundation
import XCTest
import RxBlocking
import RxSwift
@testable import SpaceX

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    
    var cancelExpectation: XCTestExpectation?
    var resumeExpectation: XCTestExpectation?
    
    func cancel() {
        
        cancelExpectation?.fulfill()
    }
        
    func resume() {
        resumeExpectation?.fulfill()
    }
}

class MockURLSession: URLSessionProtocol {
    
    func dataTaskWithURL(wity request: URLRequest, completion: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        lastURL = request.url
        completion(nil, nil, nil)
        return nextDataTask
    }
    
    var nextDataTask = MockURLSessionDataTask()
    private (set) var lastURL: URL?
}

struct MockUser: Codable {
    
    let name: String
}

struct MockAPIService {
    
    let apiService: ApiService
    
    func getUser() -> Observable<MockUser> {
        
        let endPoint = EndPoint(path: "/testPath")

        return apiService.request(with: endPoint)
    }
}

class APIServiceTests: XCTestCase {
    
    var subject: ApiService!
    let session = MockURLSession()
    
    override func setUp() {
        super.setUp()
        subject = ApiService(session: session)
    }
    
    func test_GET_StartsTheRequest() {
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask
        let resumeCalledExpecation = XCTestExpectation(description: "Resume was called")
        dataTask.resumeExpectation = resumeCalledExpecation
        let mockService = MockAPIService(apiService: subject)
        XCTAssertThrowsError(try mockService.getUser().toBlocking().first())
        wait(for: [resumeCalledExpecation], timeout: 1.0)
    }
}

