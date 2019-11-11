//
//  NYTArticlesRequest.swift
//  NYT Mars Edition
//
//  Created by Michael Valentiner on 11/11/19.
//  Copyright © 2019 Heliotropix, LLC. All rights reserved.
//

import Foundation

class NYTArticlesRequest: UnauthenticatedDecodableXMLRequest {	
	typealias RequestedDataType = [NYTArticle]
	var endpointURL: String = "http://mobile.public.ec2.nytimes.com.s3-website-us-east-1.amazonaws.com/candidates/content/v1/articles.plist"

	internal func loadArticles(onCompletion: @escaping (Result<NYTArticlesRequest.RequestedDataType, DataRequestError>) -> Void) {
		load { (dataRequestResult) in
			onCompletion(dataRequestResult)
		}
	}
}

class NYTArticleJSONRequest: UnauthenticatedDecodableJSONRequest {
	typealias RequestedDataType = [NYTArticle]
	var endpointURL: String = "http://mobile.public.ec2.nytimes.com.s3-website-us-east-1.amazonaws.com/candidates/content/v1/articles.json"
}
