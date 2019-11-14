//
//  TranslationService.swift
//  Places
//
//  Created by Michael Valentiner on 3/20/19.
//  Copyright © 2019 Michael Valentiner. All rights reserved.
//

import Foundation

internal struct TranslationServiceName {
	static let name = "TranslationService"
}

extension ServiceRegistryImplementation {
	var translationService : TranslationService {
		get {
			return serviceWith(name: TranslationServiceName.name) as! TranslationService	// Intentional forced unwrapping
		}
	}
}

protocol TranslationService : SOAService {
	func translate(article: NYTArticle) -> NYTArticle
	func translate(text: String) -> String
}

extension TranslationService {
	// MARK: Service protocol requirement
	internal var serviceName : String {
		get {
			return TranslationServiceName.name
		}
	}
	// MARK: TranslationService protocol requirement
	func translate(article: NYTArticle) -> NYTArticle {
	let model = NYTArticleModel(title: translate(text: article.model.title), body: translate(text: article.model.body), images: article.model.images)
		return NYTArticle(model: model, topImage: article.topImage, images: article.images)
	}
	
	internal func translate(text: String) -> String {
		/*
			The translation strategy is to
			1) split the text into an array or words. Words ar edelimited by whitespace
			2) apply the translation rules to the array of words.
			3) check for embedded punctuation
			4) construct the translated character stream by iterating through the initial text stream copying white space
			and replacing words from the translated words array.
		*/
		// 1) split the text into an array or words. Words ar edelimited by whitespace
		let words = text.split { $0.isWhitespace }
		// 2) apply the translation rules to the array of words.
		var translatedWords = words.map { applyRules(String($0)) }

		var translatedText = ""
		var textToTranslate = text
		var copyNextWord = true
		while let char = textToTranslate.first {
			textToTranslate = String(textToTranslate.dropFirst())

			// 3) check for embedded punctuation
			var embeddedPunctuation = false
			if let first = textToTranslate.first {
				embeddedPunctuation = copyNextWord && !first.isWhitespace
			}

			// 4) construct the translated character stream by iterating through the initial text stream copying white space
			// and replacing words from the translated words array.
			if char.isWhitespace || (char.isPunctuation && !embeddedPunctuation) {
				if copyNextWord, let nextWord = translatedWords.first {
					translatedText += String(nextWord)
					translatedWords = Array(translatedWords.dropFirst())
					copyNextWord = false
				}
				translatedText += String(char)
			} else {
				copyNextWord = true
			}
		}
		if copyNextWord, let nextWord = translatedWords.first {
			translatedText += String(nextWord)
		}

		return translatedText
	}
	
	private func applyRules(_ word: String) -> String {
	
		// ** Punctuation within words (e.g. we'll) can be discarded, all other punctuation (including paragraph spacing) must be maintained.
		// Remove punctuation.
		let strippedWord = word.filter { !$0.isPunctuation }

		// ** Numbers should not be translated unless embedded within a word. (ex. “20,000 Leagues Under the Sea” should
		//	translate to “20,000 Boinga Boinga the Sea”, whereas “fri3nd” should translate to just “boinga”.
		// Check if word is an Int or a Float
		if let _ = Int(strippedWord) {
			return strippedWord
		}

		// ** All words greater than 3 characters should be translated to the word "boinga"
		// ** Capitalization must be maintained
		let uppercaseBoinga = ["B", "O", "I", "N", "G", "A"]
		let lowercaseBoinga = ["b", "o", "i", "n", "g", "a"]
		var translatedWord: String = ""
		if strippedWord.count > 3 {
			let wordArray = Array(strippedWord)
			for i in 0..<6 {
				if i < wordArray.count, wordArray[i].isUppercase {
					translatedWord += uppercaseBoinga[i]
				} else {	// if i < strippedWord.count {
					translatedWord += lowercaseBoinga[i]
//				} else {
//					break
				}
			}
		} else {
			translatedWord = strippedWord
		}
		
		return translatedWord
	}
}

internal class TranslationServiceImplementation : TranslationService {
	static func register() {
		ServiceRegistry.add(service: TranslationServiceImplementation())
	}
}
