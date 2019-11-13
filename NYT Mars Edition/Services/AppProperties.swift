//
//  AppProperties.swift
//  Places
//
//  Created by Michael Valentiner on 3/20/19.
//  Copyright © 2019 Michael Valentiner. All rights reserved.
//

import Foundation

internal struct AppPropertiesServiceName {
	static let name = "AppPropertiesService"
}

extension ServiceRegistryImplementation {
	var appProperties : AppProperties {
		get {
			return serviceWith(name: AppPropertiesServiceName.name) as! AppProperties	// Intentional forced unwrapping
		}
	}
}

protocol AppProperties : SOAService {
	var isTranslateOn: Bool { get set }
}

extension AppProperties {
	// MARK: Service protocol requirement
	internal var serviceName : String {
		get {
			return AppPropertiesServiceName.name
		}
	}

}

internal class AppPropertiesImplementation : AppProperties {
	static func register() {
		ServiceRegistry.add(service: AppPropertiesImplementation())
	}

	@UserDefault("isTranslate", defaultValue: false)
	var isTranslateOn: Bool
}
