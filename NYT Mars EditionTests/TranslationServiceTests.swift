//
//  TranslationServiceTests.swift
//  NYT Mars EditionTests
//
//  Created by Michael Valentiner on 11/11/19.
//  Copyright © 2019 Heliotropix, LLC. All rights reserved.
//

import XCTest
@testable import NYT_Mars_Edition

class TranslationServiceTests: XCTestCase {

	var translationService = ServiceRegistry.translationService
	
    func testWordsLessThanOrEqualTo3CharactersRule() {
		// ** All words greater than 3 characters should be translated to the word "boinga"
		guard translationService.translate(text: "a") == "a" else {
			XCTFail()
			return
		}
		guard translationService.translate(text: "aa") == "aa" else {
			XCTFail("\(#function), \"aa\" failed")
			return
		}
		guard translationService.translate(text: "aaa") == "aaa" else {
			XCTFail("\(#function), \"aaa\" failed")
			return
		}
		guard translationService.translate(text: "a aa aaa") == "a aa aaa" else {
			XCTFail("\(#function), \"a aa aaa\" failed")
			return
		}
		XCTAssert(true)
    }
	
    func testWordsGreaterThan3CharactersRule() {
		// ** All words greater than 3 characters should be translated to the word "boinga"
		guard translationService.translate(text: "aaaa") == "boinga" else {
			XCTFail("\(#function), \"aaaa\" failed")
			return
		}
		guard translationService.translate(text: "aaaa aaaa") == "boinga boinga" else {
			XCTFail("\(#function), \"aaaa aaaa\" failed")
			return
		}
		XCTAssert(true)
    }

	func testNumbersRule() {
		// ** Numbers should not be translated unless embedded within a word. (ex. “20,000 Leagues Under the Sea” should translate to “20,000 Boinga Boinga the Sea”, whereas “fri3nd” should translate to just “boinga”.
		guard translationService.translate(text: "123") == "123" else {
			XCTFail("\(#function), \"123\" failed")
			return
		}
		guard translationService.translate(text: "20,000") == "20,000" else {
			XCTFail("\(#function), \"20,000\" failed")
			return
		}
		guard translationService.translate(text: "123 20,000") == "123 20,000" else {
			XCTFail("\(#function), \"123 20,000\" failed")
			return
		}
		XCTAssert(true)
	}
	
	func testCapitalizationRule() {
		guard translationService.translate(text: "ABC") == "ABC" else {
			XCTFail("\(#function), \"ABC\" failed")
			return
		}
		guard translationService.translate(text: "ABCD") == "BOINga" else {
			XCTFail("\(#function), \"ABCD\" failed")
			return
		}
		guard translationService.translate(text: "abcdE") == "boinGa" else {
			XCTFail("\(#function), \"abcdE\" failed")
			return
		}
		guard translationService.translate(text: "ABCDE") == "BOINGa" else {
			XCTFail("\(#function), \"ABCDE\" failed")
			return
		}
		guard translationService.translate(text: "AbcdeF") == "BoingA" else {
			XCTFail("\(#function), \"AbcdeF\" failed")
			return
		}
		guard translationService.translate(text: "abcdEfgha") == "boinGa" else {
			XCTFail("\(#function), \"abcdEfgha\" failed")
			return
		}
		XCTAssert(true)
	}

	func testPunctuationRule() {
		// ** Punctuation within words (e.g. we'll) can be discarded, all other punctuation (including paragraph spacing) must be maintained.
//		guard translationService.translate(text: "w'l") == "wl" else {
//			XCTFail("\(#function), \"w'l\" failed")
//			return
//		}
//		guard translationService.translate(text: "we'll") == "boinga" else {
//			XCTFail("\(#function), \"we'll\" failed")
//			return
//		}
		let result = translationService.translate(text: "May 18, abcde")
		guard result == "May 18, boinga" else {
			XCTFail("\(#function), \"May 18, abcde\" failed, result == \(result)")
			return
		}
		XCTAssert(true)
	}
}

