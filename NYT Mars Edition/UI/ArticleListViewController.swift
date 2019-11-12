//
//  ArticleListViewController.swift
//  NYT Mars Edition
//
//  Created by Michael Valentiner on 11/11/19.
//  Copyright © 2019 Heliotropix, LLC. All rights reserved.
//

import UIKit

class ArticleListViewController : UITableViewController {

	// Dependency(s)
	private var nytService: NYTService
	
	init(nytService: NYTService) {
		self.nytService = nytService

		super.init(style: .plain)

		self.nytService.nytArticles.bind { (oldArticleList, newArticleList) in
			guard oldArticleList != newArticleList else {
				// No change, so don't update the UI.
				return
			}
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	static let articleCellReuseId = "articleCell"

	override func viewDidLoad() {
		self.tableView.register(ArticleCell.self, forCellReuseIdentifier: ArticleListViewController.articleCellReuseId)
		nytService.refreshArticles()
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 1
		case 1:
			return self.nytService.nytArticles.value.count
		default:
			fatalError("\(#function), indexPath.section out of range.")
		}
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.section {
		case 0:
			let cell = UITableViewCell()
			cell.contentView.backgroundColor = .magenta
			return cell	//TODO
		case 1:
			let article = self.nytService.nytArticles.value[indexPath.row]
			guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleListViewController.articleCellReuseId, for: indexPath) as? ArticleCell else {
				return ArticleCell(for: article)
			}
			cell.configure(for: article)
			return cell
		default:
			fatalError("\(#function), indexPath.section out of range.")
		}
	}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		// TODO
		return CGFloat(50.0)
	}

	override func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
		// TODO
		return nil
	}
}

class ArticleCell: UITableViewCell {
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}

	init(for article: NYTArticleViewModel) {
		super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: ArticleListViewController.articleCellReuseId)
		configure(for: article)
		contentView.backgroundColor = .cyan
	}

	internal func configure(for article: NYTArticleViewModel) {
		textLabel?.text = article.title
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
