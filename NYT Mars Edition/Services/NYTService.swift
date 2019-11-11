//
//  NYTService.swift
//  NYT Mars Edition
//
//  Created by Michael Valentiner on 11/11/19.
//  Copyright © 2019 Heliotropix, LLC. All rights reserved.
//

import UIKit

private struct NYTServiceName {
	static let serviceName = "NYTService"
}

// Extend ServiceRegistry with some syntactic sugar for accessing the NYTService.
extension ServiceRegistryImplementation {
	var nytService: NYTService {
		get {
			return serviceWith(name: NYTServiceName.serviceName) as! NYTService	// Intentional force unwrapping
		}
	}
}

/// NYTService Interface
protocol NYTService: SOAService {
	func refreshArticles(onCompletion: @escaping (Result<NYTArticlesRequest.RequestedDataType, DataRequestError>)->Void)
}

/// NYTService default implementation
extension NYTService {
	var serviceName: String {
		get {
			return NYTServiceName.serviceName
		}
	}

	internal func refreshArticles(onCompletion: @escaping (Result<NYTArticlesRequest.RequestedDataType, DataRequestError>) -> Void) {
		NYTArticlesRequest().load { decodableRequestResult in
			onCompletion(decodableRequestResult)
		}
	}

	internal func requestTopImage(for article: NYTArticle, onCompletion: @escaping (Result<UIImage, DataRequestError>) -> Void) {
		let url = article.images.first { (nytImage) -> Bool in
			nytImage.isTopImage == true
		}
		
		guard let topImageUrl = url ?? article.images.first else {
			// TODO: handle no top image
			return
		}
		
		ImageRequest(withEndpoint: topImageUrl.url).loadImage { dataRequestResult in
			switch dataRequestResult {
			case .failure(let dataRequestError):
				onCompletion(.failure(dataRequestError))
				break
			case .success(let image):
				onCompletion(.success(image))
				break
			}
		}
	}
}

internal class NYTServiceImplementation: NYTService {
	static func register() {
		NYTServiceImplementation().register()
	}
}
