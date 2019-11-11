//
//  UnauthenticatedDecodableRequest.swift
//  NYT Mars Edition
//
//  Created by Michael Valentiner on 11/11/19.
//  Copyright © 2019 Heliotropix, LLC. All rights reserved.
//

import Foundation

typealias DecodableRequestResult<RequestedDataType> = Result<RequestedDataType, DataRequestError>

/// UnauthenticatedDataRequest - http request to request data of associated type <RequestedDataType> returning objects of <RequestedDataType>
protocol UnauthenticatedDecodableRequest: UnauthenticatedDataRequest {
	// Define the type of data being requested.
	associatedtype RequestedDataType: Decodable

	// Funtion to transform returned Data to RequestedDataType
    func decode<RequestedDataType>(_ type: RequestedDataType.Type, from data: Data) throws -> RequestedDataType where RequestedDataType : Decodable
}

extension UnauthenticatedDecodableRequest {
	internal func load(onCompletion: @escaping (DecodableRequestResult<RequestedDataType>) -> Void) {
		_load { (dataRequestResult) in
			switch dataRequestResult {
			case .failure(let error):
				onCompletion(DecodableRequestResult<RequestedDataType>.failure(error))
				return
			case .success(let data):
				// Decode the data
				guard let decodedData = self.decode(data) else {
					onCompletion(DecodableRequestResult<RequestedDataType>.failure(.decodeDataError))
					return
				}
				// Success
				onCompletion(DecodableRequestResult<RequestedDataType>.success(decodedData))
			}
		}
	}

	private func decode(_ data: Data) -> RequestedDataType? {
		do {
			let decodedData = try self.decode(RequestedDataType.self, from: data) // Decoding our data
			return decodedData
		}
		catch {
			return nil
		}
	}
}

/// UnauthenticatedDecodableXMLRequest - http request to request JSON of associated type <RequestedDataType> and return objects of <RequestedDataType>
protocol UnauthenticatedDecodableJSONRequest: UnauthenticatedDecodableRequest {
}

extension UnauthenticatedDecodableJSONRequest {
	func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
		return try JSONDecoder().decode(T.self, from: data) // Decoding our data
	}
}

/// UnauthenticatedDecodableXMLRequest - http request to request XML of associated type <RequestedDataType> and return objects of <RequestedDataType>
protocol UnauthenticatedDecodableXMLRequest: UnauthenticatedDecodableRequest {
}

extension UnauthenticatedDecodableXMLRequest {
	func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
		return try PropertyListDecoder().decode(T.self, from: data) // Decoding our data
	}
}
