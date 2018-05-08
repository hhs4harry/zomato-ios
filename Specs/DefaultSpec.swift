//
//  Specs.swift
//  Specs
//
//  Created by Harry on 9/05/18.
//  Copyright © 2018 |x|. All rights reserved.
//

final class DefaultSpec: XCTestCase {

	func defaultTest() {
		let defaultValue: String = Default.test
		XCTAssert(defaultValue == "delete this file")
	}
}

import XCTest

@testable import HSProject
