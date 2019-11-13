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

/// MainAppCoordinator aggregates the generic functionality of ViewControllerCoordinator with the app specific navigation functions defined here.
protocol MainAppCoordinator: ViewControllerCoordinator {
	func presentArticleListScreen()
	func presentArticleScreen()
}

internal class AppNavigationCoordinator: MainAppCoordinator {
	/// RootController
	var rootController: UINavigationController
	init(using rootController: UINavigationController) {
		self.rootController = rootController
	}
	
	internal func presentArticleListScreen() {
		let articleListViewController = ArticleListViewController(appProperties: ServiceRegistry.appProperties, nytService: ServiceRegistry.nytService,
			translationService: ServiceRegistry.translationService)
		present(articleListViewController)
	}

	/// Navigation
	internal func presentArticleScreen() {
//		print(#function)
//		let hostingController = UIHostingController(rootView: contentView)
//		present(hostingController)
	}
}
