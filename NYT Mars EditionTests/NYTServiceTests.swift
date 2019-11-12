//
//  NYTServiceTests.swift
//  NYT Mars EditionTests
//
//  Created by Michael Valentiner on 11/11/19.
//  Copyright © 2019 Heliotropix, LLC. All rights reserved.
//

import XCTest
@testable import NYT_Mars_Edition

class NYTServiceTests: XCTestCase {
	
	var nytService: NYTService = ServiceRegistry.nytService

    func testNYTService_refreshArticles() {
    	let expectation = XCTestExpectation(description: "Test NYTArticlesRequestTests.testNYTArticlesRequest_loadArticles")

		self.nytService.nytArticles.bind { (oldArticleList, newArticleList) in
			guard oldArticleList != newArticleList else {
				// No change, so don't update the UI.
				return
			}
			XCTAssertTrue(true)
			expectation.fulfill()
		}

		nytService.refreshArticles()
		
		wait(for: [expectation], timeout: 10.0)
    }
}
