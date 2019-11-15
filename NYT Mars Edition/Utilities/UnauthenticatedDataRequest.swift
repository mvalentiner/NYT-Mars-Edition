//
//	UnauthenticatedDataRequest.swift
//  NYT Mars Edition
//
//  Created by Michael Valentiner on 11/11/19.
//  Copyright © 2019 Heliotropix, LLC. All rights reserved.
//
//	Inspired by http://matteomanferdini.com/network-requests-rest-apis-ios-swift/
//

import UIKit

/// Error types for DataRequestResult
enum DataRequestError: Error {
	case badURLError
	case badURLRequestError
	case decodeDataError
	case encodeDataError
	case httpStatusError(Int)
	case nilDataError
	case notAuthenticatedError
	case sessionDataTaskError(Error)

	internal init(error: Error) {
		self = .sessionDataTaskError(error)
	}

	internal init(httpStatus: Int) {
		self = .httpStatusError(httpStatus)
	}
}

typealias DataRequestResult = Result<Data, DataRequestError>

/// UnauthenticatedDataRequest - http request to request Data
protocol UnauthenticatedDataRequest {
	// Define the endpoint to call.
	var endpointURL: String { get }
	// Request the data.
	func load(onCompletion: @escaping (DataRequestResult) -> Void)

	// Extension point for subtypes
	func makeRequest(for url: URL) -> URLRequest
}

extension UnauthenticatedDataRequest {
	internal func makeRequest(for url: URL) -> URLRequest {
		return URLRequest(url: url)
	}

	internal func load(onCompletion: @escaping (DataRequestResult) -> Void) {
        _load(onCompletion: onCompletion)
	}

	internal func _load(onCompletion: @escaping (DataRequestResult) -> Void) {
        guard let url = URL(string: endpointURL) else {
			onCompletion(DataRequestResult.failure(.badURLError))
			return
        }
		let request = makeRequest(for: url)
		sendRequest(request, onCompletion: onCompletion)
	}

	private func sendRequest(_ request: URLRequest, onCompletion: @escaping (DataRequestResult) -> Void) {
		// Issue the request
		let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
		let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
			// Make sure we have a HTTPURLResponse
			guard let httpResponse = response as? HTTPURLResponse else {
				onCompletion(DataRequestResult.failure(.badURLRequestError))
				return
			}

			// Handle any error
			if let error = error {
				onCompletion(DataRequestResult.failure(.sessionDataTaskError(error)))
				return
			}

			// Ensure we got an acceptable http status
			let statusCode = httpResponse.statusCode
			guard self.shouldContinue(withHTTPStatusCode : statusCode) == true else {
                onCompletion(DataRequestResult.failure(.httpStatusError(statusCode)))
 				return
            }

			// Ensure we received data
			guard let data = data else {
				onCompletion(DataRequestResult.failure(.nilDataError))
				return
			}

			onCompletion(DataRequestResult.success(data))
		})
		task.resume()
	}

	private func shouldContinue(withHTTPStatusCode statusCode : Int) -> Bool {
		guard statusCode < 300 else {
			return false
		}
		return true
	}
}
