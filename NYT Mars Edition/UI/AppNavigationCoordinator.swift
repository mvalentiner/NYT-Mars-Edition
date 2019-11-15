//
//  AppNavigationCoordinator.swift
//  NYT Mars Edition
//
//  Created by Michael Valentiner on 11/11/19.
//  Copyright © 2019 Heliotropix, LLC. All rights reserved.
//
//	Inspired by https://www.hackingwithswift.com/articles/71/how-to-use-the-coordinator-pattern-in-ios-apps

import CoreLocation
import SwiftUI
import UIKit

/// MainAppCoordinator aggregates the generic functionality of ViewControllerCoordinator with the app specific navigation functions.
protocol MainAppCoordinator: ViewControllerCoordinator {
	func presentArticleListScreen()
	func presentArticleScreen(articleId: Int) -> Void
}

internal class AppNavigationCoordinator: MainAppCoordinator {

	var rootController: UINavigationController

	init(using rootController: UINavigationController) {
		self.rootController = rootController
	}
	
	internal func presentArticleListScreen() {
		let articleListViewController = ArticleListViewController(appProperties: ServiceRegistry.appProperties, nytService: ServiceRegistry.nytService,
			translationService: ServiceRegistry.translationService, handleArticleSelect: presentArticleScreen)
		present(articleListViewController)
	}

	internal func presentArticleScreen(articleId: Int) -> Void {
		guard var article = ServiceRegistry.nytService.nytArticle(for: articleId) else {
			return
		}

		if ServiceRegistry.appProperties.isTranslateOn.value {
			article = ServiceRegistry.translationService.translate(article: article)
		}

		let articleScreen = ArticleScreen(article: article)
		let hostingController = UIHostingController(rootView: articleScreen)
		present(hostingController)
	}
}
