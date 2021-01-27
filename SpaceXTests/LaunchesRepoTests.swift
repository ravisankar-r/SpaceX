//
//  LaunchesRepoTests.swift
//  SpaceXTests
//
//  Created by Ravisankar on 26/01/21.
//

import Foundation
import XCTest
import RxSwift
@testable import SpaceX

class LaunchesRepoTests: XCTestCase {
    
    func testGetLaunches() {
        
        let repo = LaunchesRepo()
        let expectation = XCTestExpectation(description: "test")
        _ = repo.getLaunches().subscribe(onNext: { welcome in
            
            print(welcome)
            expectation.fulfill()
            
        } , onError: { error in
            
            print(error)
            expectation.fulfill()
            
        })
        wait(for: [expectation], timeout: 10.0)
    }
}
