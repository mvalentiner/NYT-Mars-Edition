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

struct NYTArticle: Equatable {
	let model: NYTArticleModel
	let topImage: UIImage
	let images: [UIImage]
}

/// NYTService Interface
protocol NYTService: SOAService {
	var nytArticles: Bindable<[NYTArticle]> { get set }
	func nytArticle(for id: Int) -> NYTArticle?
	func refreshArticles()
}

/// NYTService default implementation
extension NYTService {
	var serviceName: String {
		get {
			return NYTServiceName.serviceName
		}
	}
}

internal class NYTServiceImplementation: NYTService {
	static func register() {
		NYTServiceImplementation().register()
	}

	internal var nytArticles = Bindable<[NYTArticle]>([])
	private var nytArticleDict = Dictionary<Int, NYTArticle>()

	init() {
		// Keep the nytArticleDict insync with nytArticles array.
    	nytArticles.bind { (_, newArticles) in
			newArticles.forEach { (article) in
				self.nytArticleDict[article.model.id] = article
			}
		}
	}

	internal let articleAccessQueue = DispatchQueue(label: "ArticleAccessQueue", attributes: .concurrent)
	private func append(article viewModel: NYTArticle) {
		articleAccessQueue.sync(flags: .barrier) {
			self.nytArticles.value.append(viewModel)
		}
	}

	func nytArticle(for id: Int) -> NYTArticle? {
		return nytArticleDict[id]
	}
	
	internal func refreshArticles() {
		nytArticles.value.removeAll()
		NYTArticlesRequest().load { decodableRequestResult in
			switch decodableRequestResult {
			case .failure(let dataRequestError):
				// TODO: show error alert
				print("\(#function): dataRequestError == \(dataRequestError)")
				break
			case .success(let articles):
				articles.forEach { (article) in
					self.requestTopImage(for: article) { result in
						switch result {
						case .failure(let dataRequestError):
							// TODO: handle no top image
							print("\(#function): dataRequestError == \(dataRequestError)")
							break
						case .success(let image):
							let viewModel = NYTArticle(model: article, topImage: image, images: [image])
							self.append(article: viewModel)
							break
						}
					}
				}
				break
			}
		}
	}

	private func requestTopImage(for article: NYTArticleModel, onCompletion: @escaping (Result<UIImage, DataRequestError>) -> Void) {
		let url = article.images.first { $0.isTopImage == true }
		guard let topImageUrl = url ?? article.images.first else {
			// No top image
			onCompletion(.failure(.nilDataError))
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

// Extend ServiceRegistry with some syntactic sugar for accessing the NYTService.
extension ServiceRegistryImplementation {
	var nytService: NYTService {
		get {
			return serviceWith(name: NYTServiceName.serviceName) as! NYTService	// Intentional force unwrapping
		}
	}
}
