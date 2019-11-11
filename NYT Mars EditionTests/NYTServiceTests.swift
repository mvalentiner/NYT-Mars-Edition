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
	
	let nytService: NYTService = ServiceRegistry.nytService

    func testNYTService_refreshArticles() {
    	let expectation = XCTestExpectation(description: "Test NYTArticlesRequestTests.testNYTArticlesRequest_loadArticles")

		nytService.refreshArticles { dataRequestResult in
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

	func testNYTService_requestTopImage() {
		let nytImage = NYT_Mars_Edition.NYTImage(width: 100, height: 100, url: "http://mobile.public.ec2.nytimes.com.s3-website-us-east-1.amazonaws.com/candidates/images/img2.jpg", isTopImage: true)
		let article = NYT_Mars_Edition.NYTArticle(title: "mock Title", body: "mock Body", images: [nytImage])
		nytService.requestTopImage(for: article) { (result) in
			switch result {
			case .failure(let dataRequestError):
				XCTAssertTrue(false, "\(#function): dataRequestError == \(dataRequestError.localizedDescription)")
			case .success(_):
				XCTAssertTrue(true)
			}
		}
	}
}
