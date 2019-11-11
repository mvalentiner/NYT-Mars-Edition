//
//  ViewControllerCoordinator.swift
//  NYT Mars Edition
//
//  Created by Michael Valentiner on 11/11/19.
//  Copyright © 2019 Heliotropix, LLC. All rights reserved.
//
//	Inspired by https://www.hackingwithswift.com/articles/71/how-to-use-the-coordinator-pattern-in-ios-apps

import CoreLocation
import UIKit

protocol ViewControllerCoordinator {
	var rootController: UINavigationController { get }

	func present(_ viewController: UIViewController, animated: Bool)
	
	func popViewController(animated: Bool)

	func popToRootController(animated: Bool)
}

extension ViewControllerCoordinator {
	func present(_ viewController: UIViewController, animated: Bool = true) {
		rootController.pushViewController(viewController, animated: animated)
	}
	
	func popViewController(animated: Bool = true) {
		rootController.popViewController(animated: animated)
	}

	func popToRootController(animated: Bool = true) {
		rootController.popToRootViewController(animated: animated)
	}
}
