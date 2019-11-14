//
//  ArticleScreen.swift
//  NYT Mars Edition
//
//  Created by Michael Valentiner on 11/13/19.
//  Copyright © 2019 Heliotropix, LLC. All rights reserved.
//

import SwiftUI

struct ArticleScreen: View {
	internal let article: NYTArticle

	private let padding = CGFloat(50.0)

    var body: some View {
		GeometryReader{ geometery in
			ScrollView {
				VStack {
					Text(self.article.model.title)
						.font(.custom("TimesNewRomanPS-BoldMT", size: CGFloat(30.0)))
						.fontWeight(.semibold)
						.frame(width: geometery.size.width - self.padding, alignment: .topLeading)
						.multilineTextAlignment(.leading)
						.padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
					Image(uiImage: self.article.topImage).resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: geometery.size.width - self.padding, alignment: .center)
					Text(self.article.model.body)
						.font(.custom("TimesNewRomanPSMT", size: CGFloat(15.0)))
						.fontWeight(Font.Weight.regular)
						.frame(width: geometery.size.width - self.padding, alignment: .topLeading)
						.multilineTextAlignment(.leading)
						.padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
				}
			}
		}
    }
}

struct ArticleScreen_Previews: PreviewProvider {
    static var previews: some View {
    	let mockArticle = NYTArticle(
			model: NYTArticleModel(
				title: "Lorem ipsum",
				body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
				images: []),
			topImage: UIImage(named: "image_placeholder")!, images: [])
		return ArticleScreen(article: mockArticle)
    }
}
