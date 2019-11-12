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

struct NYTArticleViewModel: Equatable {
	let id: Int
	let title: String
	let body: String
	let images: UIImage
}

/// NYTService Interface
protocol NYTService: SOAService {
	var nytArticles: Bindable<[NYTArticleViewModel]> { get set }
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

	internal var nytArticles = Bindable<[NYTArticleViewModel]>([])
//	private var knownArticleSet = Set<Int>()
	
	internal func refreshArticles() {
		self.nytArticles.value.removeAll()
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
//							guard self.knownArticleSet.contains(article.id) == false else {
//								return
//							}
//							self.knownArticleSet.insert(article.id)
							let viewModel = NYTArticleViewModel(id: article.id, title: article.title, body: article.body, images: image)
							self.nytArticles.value.append(viewModel)
							break
						}
					}
				}
				break
			}
		}
	}

	private func requestTopImage(for article: NYTArticle, onCompletion: @escaping (Result<UIImage, DataRequestError>) -> Void) {
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
