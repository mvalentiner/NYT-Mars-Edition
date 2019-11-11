//
//  ImageRequest.swift
//  NYT Mars Edition
//
//  Created by Michael Valentiner on 11/11/19.
//  Copyright © 2019 Heliotropix, LLC. All rights reserved.
//

import UIKit

class ImageRequest: UnauthenticatedDataRequest {
	var endpointURL: String
	init(withEndpoint url: String) {
		self.endpointURL = url
	}

	internal func loadImage(onCompletion: @escaping (DecodableRequestResult<UIImage>) -> Void) {
		load { (dataRequestResult) in
			switch dataRequestResult {
			case .failure(let dataRequestError):
				onCompletion(.failure(dataRequestError))
				break
			case .success(let data):
				guard let image = UIImage(data: data) else {
					onCompletion(.failure(.decodeDataError))
					break
				}
				onCompletion(.success(image))
				break
			}
		}
	}
}
