//
//  AppDelegate.swift
//  NYT Mars Edition
//
//  Created by Michael Valentiner on 11/11/19.
//  Copyright © 2019 Heliotropix, LLC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	// Bootstrap App Services
	// This declaration causes the app ServiceRegistry to be instantiated and services to be registered
	// prior to application(_ application:, didFinishLaunchingWithOptions:) being called.
	private let serviceRegistry: ServiceRegistryImplementation = {
		AppPropertiesImplementation.register()
		NYTServiceImplementation.register()
		TranslationServiceImplementation.register()
		return ServiceRegistry
	}()

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		return true
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
	}
}
