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
	func translate(article: NYTArticle) -> NYTArticle
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
	func translate(article: NYTArticle) -> NYTArticle {
	let model = NYTArticleModel(title: translate(text: article.model.title), body: translate(text: article.model.body), images: article.model.images)
		return NYTArticle(model: model, topImage: article.topImage, images: article.images)
	}
	
	internal func translate(text: String) -> String {
		return "This is Martian"
	}
}

internal class TranslationServiceImplementation : TranslationService {
	static func register() {
		ServiceRegistry.add(service: TranslationServiceImplementation())
	}
}
