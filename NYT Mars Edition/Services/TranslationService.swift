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
	var appProperties: AppProperties { get }
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
		guard appProperties.isTranslateOn else {
			return text
		}
		return applyRules(text: text)
	}
	private func applyRules(text: String) -> String {
		return text
	}
}

internal class TranslationServiceImplementation : TranslationService {
	static func register(appProperties: AppProperties) {
		ServiceRegistry.add(service: TranslationServiceImplementation(appProperties: appProperties))
	}
	
	let appProperties: AppProperties
	
	init(appProperties: AppProperties) {
		self.appProperties = appProperties
	}
}
