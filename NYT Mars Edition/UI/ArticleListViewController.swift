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
	private var appProperties: AppProperties
	private var nytService: NYTService

	// ViewModel for the ArticleListViewController
	fileprivate struct NYTArticleSummaryViewModel: Equatable {
		let id: Int
		let title: String
		let image: UIImage
		let shouldTranslate: Bool

		init(from article: NYTArticle, using translationService: TranslationService, shouldTranslate: Bool) {
			self.id = article.model.id
			self.title = shouldTranslate ? translationService.translate(text: article.model.title) : article.model.title
			self.image =  article.topImage
			self.shouldTranslate = shouldTranslate
		}
	}

	// ViewModel
	private var articleSummaries = Bindable<[NYTArticleSummaryViewModel]>([])

	// Action(s)
	let handleArticleSelect: (Int) -> Void

	init(appProperties: AppProperties, nytService: NYTService, translationService: TranslationService, handleArticleSelect: @escaping (Int) -> Void) {
		self.appProperties = appProperties
		self.nytService = nytService
		self.handleArticleSelect = handleArticleSelect

		super.init(style: .plain)

		self.setNavTitle(isTranslateOn: appProperties.isTranslateOn.value)

		// Bind to NYTService.nytArticles to update view model when there are new nytArticles.
		self.nytService.nytArticles.bind { (oldArticleList, newArticleList) in
			guard oldArticleList != newArticleList else {
				// No change, so don't update the UI.
				return
			}
			// Transform NYTService.nytArticles into NYTArticleSummaryViewModels
			self.articleSummaries.value.removeAll()
			let summaries = newArticleList.map {
				NYTArticleSummaryViewModel(from: $0, using: translationService, shouldTranslate: appProperties.isTranslateOn.value)
			}
			self.articleSummaries.value.append(contentsOf: summaries)
		}

		// Bind to NYTService.nytArticles to update the UI when it changes.
		self.articleSummaries.bind { (oldArticleList, newArticleList) in
			guard oldArticleList != newArticleList else {
				// No change, so don't update the UI.
				return
			}
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}

		// Bind to self.appProperties.isTranslateOn to update the UI when it changes.
		self.appProperties.isTranslateOn.bind { (oldValue, newValue) in
			guard oldValue != newValue else {
				// No change, so don't update the UI.
				return
			}
			// Transform NYTService.nytArticles into NYTArticleSummaryViewModels
			self.articleSummaries.value.removeAll()
			let summaries = self.nytService.nytArticles.value.map {
				NYTArticleSummaryViewModel(from: $0, using: translationService, shouldTranslate: newValue)
			}
			self.articleSummaries.value.append(contentsOf: summaries)
			
			self.setNavTitle(isTranslateOn: newValue)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	fileprivate static let articleCellReuseId = "articleCell"
	fileprivate static let translateSwitchCellReuseId = "translateSwitchCell"

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
			return self.articleSummaries.value.count
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
			cell.configure(with: self.appProperties.isTranslateOn.value, andSwitchToggleHandler: handleTranslateToggle)
			return cell

		case 1:
			guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleListViewController.articleCellReuseId, for: indexPath) as? ArticleCell else {
				fatalError("\(#function), table cell of type ArticleCell is not registered.")
			}
			let article = self.articleSummaries.value[indexPath.row]
			cell.configure(for: article)
			return cell

		default:
			fatalError("\(#function), indexPath.section out of range.")
		}
	}

	static let articleCellHeight = CGFloat(100.0)

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch indexPath.section {
		case 0:
			return CGFloat(50.0)
		case 1:
			return ArticleListViewController.articleCellHeight
		default:
			fatalError("\(#function), indexPath.section out of range.")
		}
	}

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let article = articleSummaries.value[indexPath.row]
		self.handleArticleSelect(article.id)
	}
	
	private func handleTranslateToggle(isOn: Bool) {
		self.appProperties.isTranslateOn.value = isOn
	}
	
	private func setNavTitle(isTranslateOn: Bool) {
		let label = UILabel()
		let title = isTranslateOn ? "NYT Martian Edition" : "NYT"
		let attributes = [NSAttributedString.Key.font: UIFont(name: "TimesNewRomanPS-BoldMT", size: CGFloat(20.0)) as Any]
		label.attributedText = NSAttributedString(string: title, attributes: attributes)
		self.navigationItem.titleView = label
	}
}

fileprivate class TranslateSwitchCell: UITableViewCell  {
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

		let label = UILabel()
		let attributes = [NSAttributedString.Key.font: UIFont(name: "TimesNewRomanPS-BoldMT", size: CGFloat(20.0)) as Any]
		label.attributedText = NSAttributedString(string: "Translate", attributes: attributes)
		contentView.addSubview(label)
		label.anchorTo(right: switchView.leftAnchor, rightPadding: 10.0)
		label.anchorToYCenterOfParent()
	}

	fileprivate func configure(with switchState: Bool, andSwitchToggleHandler handler: @escaping (Bool) -> Void) {
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

fileprivate class ArticleCell: UITableViewCell {
	let thunmbnailImageView: UIImageView = {
		let image = UIImageView(image: UIImage(named: "image_placeholder"))
		image.contentMode = .scaleAspectFit
		return image
	}()
	let titleLabel: UILabel = {
		let label = UILabel()
		label.adjustsFontSizeToFitWidth = true
		label.lineBreakMode = .byWordWrapping
		label.numberOfLines = 5
		return label
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		contentView.addSubview(thunmbnailImageView)
		contentView.addSubview(titleLabel)
	}

	fileprivate func configure(for article: ArticleListViewController.NYTArticleSummaryViewModel) {
		thunmbnailImageView.image = article.image
		// Position the image view
		thunmbnailImageView.anchorTo(left: contentView.leftAnchor, leftPadding: 20.0)
		thunmbnailImageView.anchorToYCenterOfParent()
		// Size the image view
		let cgImage = article.image.cgImage!
		let height = min(ArticleListViewController.articleCellHeight - 10.0, CGFloat(cgImage.height))
		let scale = height / CGFloat(cgImage.height)
		let width = CGFloat(cgImage.width) * scale
		thunmbnailImageView.constrainTo(width: width)
		thunmbnailImageView.constrainTo(height: height)

		let font = UIFont(name: "TimesNewRomanPS-BoldMT", size: CGFloat(18.0)) as Any
		let paragraphStyle: NSMutableParagraphStyle = {
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.alignment = .left
			paragraphStyle.lineBreakMode = .byWordWrapping
			return paragraphStyle
		}()
		let attributes: [NSAttributedString.Key: Any] = [
			.font: font,
			.paragraphStyle: paragraphStyle
		]
		titleLabel.attributedText = NSAttributedString(string: article.title, attributes: attributes)
		// Position the label
		titleLabel.anchorTo(left: thunmbnailImageView.rightAnchor, top: contentView.topAnchor, right: contentView.rightAnchor, bottom: contentView.bottomAnchor,
			leftPadding: 20.0, topPadding: 10.0, rightPadding: 20.0, bottomPadding: 10.0)
		// Size the label
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
