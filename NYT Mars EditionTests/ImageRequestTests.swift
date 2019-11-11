//
//  ImageRequestTests.swift
//  NYT Mars EditionTests
//
//  Created by Michael Valentiner on 11/11/19.
//  Copyright © 2019 Heliotropix, LLC. All rights reserved.
//

import XCTest
@testable import NYT_Mars_Edition

class ImageRequestTests: XCTestCase {

    func testImageRequest_loadImage() {
    	let expectation = XCTestExpectation(description: "Test NYTArticlesRequestTests.testNYTArticlesRequest_loadArticles")

		ImageRequest(withEndpoint: "http://mobile.public.ec2.nytimes.com.s3-website-us-east-1.amazonaws.com/candidates/images/img1.jpg").loadImage { imageRequestResult in
			switch imageRequestResult {
			case .failure(let dataRequestError):
				XCTFail("\(#function): dataRequestError == \(dataRequestError.localizedDescription)")
				break

			case .success(_):
				XCTAssertTrue(true)
				break
			}
			expectation.fulfill()
		}
		
		wait(for: [expectation], timeout: 10.0)
	}
}
