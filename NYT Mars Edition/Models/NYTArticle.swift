//
//  NYTArticle.swift
//  NYT Mars Edition
//
//  Created by Michael Valentiner on 11/11/19.
//  Copyright © 2019 Heliotropix, LLC. All rights reserved.
//

import UIKit

struct NYTArticle: Decodable, Identifiable {
	let id: Int
	let title: String
	let body: String
	let images: [NYTImage]

	enum CodingKeys: CodingKey {
	  case id, title, body, images
	}

	init(title: String, body: String, images: [NYTImage]) {
		var hasher = Hasher()
		hasher.combine(title)
		hasher.combine(body)
		self.id = hasher.finalize()
    	self.title = title
		self.body = body
		self.images = images
	}

    init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		title = try container.decode(String.self, forKey: .title)
		body = try container.decode(String.self, forKey: .body)
		images = try container.decode(Array<NYTImage>.self, forKey: .images)
		var hasher = Hasher()
		hasher.combine(title)
		hasher.combine(body)
		self.id = hasher.finalize()
	}
	
	var topImageUrl: String? {
		get {
			return images.first { $0.isTopImage }?.url
		}
	}
}

struct NYTImage: Decodable {
	let width: Int
	let height: Int
	let url: String
	let isTopImage: Bool

	enum CodingKeys: String, CodingKey {
	  case width, height, url, isTopImage = "top_image"
	}
}
