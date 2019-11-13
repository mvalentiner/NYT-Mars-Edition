//
//  ArticleListViewController.swift
//  NYT Mars Edition
//
//  Created by Michael Valentiner on 11/11/19.
//  Copyright © 2019 Heliotropix, LLC. All rights reserved.
//

import UIKit

class ArticleListViewController : UITableViewController {

	// ViewModel for the ArticleListViewController
	struct NYTArticleSummaryViewModel: Equatable {
		let id: Int
		let title: String
		let image: UIImage
	}

	// Dependency(s)
	private var appProperties: AppProperties
	private var nytService: NYTService
	private var translationService: TranslationService

	// ViewModel
	var articleSummaries = Bindable<[NYTArticleSummaryViewModel]>([])
	
	init(appProperties: AppProperties, nytService: NYTService, translationService: TranslationService) {
		self.appProperties = appProperties
		self.nytService = nytService
		self.translationService = translationService

		super.init(style: .plain)

		self.articleSummaries.bind { (oldArticleList, newArticleList) in
			guard oldArticleList != newArticleList else {
				// No change, so don't update the UI.
				return
			}
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}

		// Bind to NYTService.nytArticles
		self.nytService.nytArticles.bind { (oldArticleList, newArticleList) in
			guard oldArticleList != newArticleList else {
				// No change, so don't update the UI.
				return
			}
			// Transform NYTService.nytArticles into NYTArticleSummaryViewModels
			let summaries = newArticleList.map {
				NYTArticleSummaryViewModel(id: $0.model.id, title: translationService.translate(text: $0.model.title), image: $0.topImage)
			}
			self.articleSummaries.value.append(contentsOf: summaries)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	static let articleCellReuseId = "articleCell"
	static let translateSwitchCellReuseId = "translateSwitchCell"

	override func viewDidLoad() {
		self.tableView.register(ArticleCell.self, forCellReuseIdentifier: ArticleListViewController.articleCellReuseId)
		self.tableView.register(TranslateSwitchCell.self, forCellReuseIdentifier: ArticleListViewController.translateSwitchCellReuseId)
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
			guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleListViewController.translateSwitchCellReuseId, for: indexPath) as? TranslateSwitchCell else {
				fatalError("\(#function), table cell of type TranslateSwitchCell is not registered.")
			}
			cell.configure(with: self.appProperties.isTranslateOn, andSwitchToggleHandler: handleTranslateToggle)
			return cell

		case 1:
			guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleListViewController.articleCellReuseId, for: indexPath) as? ArticleCell else {
				fatalError("\(#function), table cell of type ArticleCell is not registered.")
			}
			let article = self.nytService.nytArticles.value[indexPath.row]
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
	
	private func handleTranslateToggle(isOn: Bool) {
		self.appProperties.isTranslateOn = isOn
//		self.tableView.reloadData()
	}
}

class TranslateSwitchCell: UITableViewCell  {
	// Subview
	private let switchView = UISwitch()

	// Event handler to be called when the switch is toggled.
	private var switchToggleHandler: ((Bool) -> Void)?

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		switchView.addTarget(self, action: #selector(handleToggle), for: UIControl.Event.touchUpInside)
		contentView.addSubview(switchView)
		switchView.anchorTo(right: contentView.rightAnchor, rightPadding: 20.0)
		switchView.anchorToYCenterOfParent()
	}

	internal func configure(with switchState: Bool, andSwitchToggleHandler handler: @escaping (Bool) -> Void) {
		switchView.setOn(switchState, animated: false)
		self.switchToggleHandler = handler
	}

	@objc func handleToggle(_ sender: UISwitch) {
		self.switchToggleHandler?(sender.isOn)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

class ArticleCell: UITableViewCell {
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}

	init(for article: NYTArticle) {
		super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: ArticleListViewController.articleCellReuseId)
		configure(for: article)
		contentView.backgroundColor = .cyan
	}

	internal func configure(for article: NYTArticle) {
		textLabel?.text = article.model.title
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
