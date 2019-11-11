//
//  ArticleListViewController.swift
//  NYT Mars Edition
//
//  Created by Michael Valentiner on 11/11/19.
//  Copyright © 2019 Heliotropix, LLC. All rights reserved.
//

import UIKit

private struct ArticleListViewModel: Hashable {
	let articleId: UUID
	let title: String
	let image: UIImage
}

class ArticleListViewController : UITableViewController {

	// Dependency(s)
	private let nytService: NYTService

	// View model
	private var articles = Bindable<Set<ArticleListViewModel>>([])
	
	init(nytService: NYTService) {
		self.nytService = nytService

		super.init(style: .plain)
		
		self.articles.bind { (oldArticleList, newArticleList) in
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		refreshArticles()
	}
	
	private func refreshArticles() {
		nytService.refreshArticles() { dataRequestResult in
			switch dataRequestResult {
			case .failure(let dataRequestError):
				// TODO: show error alert
				print("\(#function): dataRequestError == \(dataRequestError)")
				break
			case .success(let articles):
				articles.forEach { (article) in
					self.requestTopImage(for: article)
				}
				break
			}
		}
	}

	private func requestTopImage(for article: NYTArticle) {
		nytService.requestTopImage(for: article) { result in
			switch result {
			case .failure(let dataRequestError):
				// TODO: show error alert
				print("\(#function): dataRequestError == \(dataRequestError)")
				break
			case .success(let image):
				let viewModel = ArticleListViewModel(articleId: article.id, title: article.title, image: image)
				self.articles.value.insert(viewModel)
				break
			}
		}
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell()
	}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return CGFloat()
	}

	override func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
		return nil
	}

	
}
