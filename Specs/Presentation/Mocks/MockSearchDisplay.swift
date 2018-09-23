//
//  MockSearchDisplay.swift
//  Specs
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

final class MockSearchDisplay: MockDisplay, SearchDisplay {
    private(set) var placeholder: String?
    func set(placeholder: String) {
        self.placeholder = placeholder
    }

    private(set) var results: [Result]?
    func show(results: [Result]) {
        self.results = results
    }
}

@testable import zomato
