//
//  NYTArticlesRequestTests.swift
//  NYT Mars EditionTests
//
//  Created by Michael Valentiner on 11/11/19.
//  Copyright © 2019 Heliotropix, LLC. All rights reserved.
//

import XCTest
@testable import NYT_Mars_Edition

class NYTArticlesRequestTests: XCTestCase {
    func testNYTArticlesRequest_loadArticles() {
    	let expectation = XCTestExpectation(description: "Test NYTArticlesRequestTests.testNYTArticlesRequest_loadArticles")

		NYTArticlesRequest().load { dataRequestResult in
			switch dataRequestResult {
			case .failure(let dataRequestError):
				XCTAssertTrue(false, "\(#function): dataRequestError == \(dataRequestError.localizedDescription)")
				break

			case .success(let articles):
				guard articles.count == 3 else {
					XCTAssertTrue(false, "\(#function): articles.count != 3")
					break
				}
				XCTAssertTrue(true)
				break
			}
			expectation.fulfill()
		}
		
		wait(for: [expectation], timeout: 10.0)
    }
}
