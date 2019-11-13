//
//  TranslationService.swift
//  Places
//
//  Created by Michael Valentiner on 3/20/19.
//  Copyright © 2019 Michael Valentiner. All rights reserved.
//

import Foundation

internal struct TranslationServiceName {
	static let name = "TranslationService"
}

extension ServiceRegistryImplementation {
	var translationService : TranslationService {
		get {
			return serviceWith(name: TranslationServiceName.name) as! TranslationService	// Intentional forced unwrapping
		}
	}
}

protocol TranslationService : SOAService {
	func translate(text: String) -> String
}

extension TranslationService {
	// MARK: Service protocol requirement
	internal var serviceName : String {
		get {
			return TranslationServiceName.name
		}
	}
	// MARK: TranslationService protocol requirement
	internal func translate(text: String) -> String {
		return "This is Martian"
	}
}

internal class TranslationServiceImplementation : TranslationService {
	static func register() {
		ServiceRegistry.add(service: TranslationServiceImplementation())
	}
}
