//
//  SearchPresenterSpec.swift
//  Specs
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

final class SearchPresenterSpec: QuickSpec {
    var presenter: SearchPresenter!
    var display: MockSearchDisplay!
    var router: MockSearchRouter!

    override func spec() {
        describe("a SearchPresenter") {
            beforeEach {
                self.display = MockSearchDisplay()
                self.router = MockSearchRouter()
                self.presenter = SearchPresenter(display: self.display, router: self.router)
            }

            afterEach {
                self.presenter = nil
            }

            self.resolve()
        }
    }

    func resolve() {
        it("resolves its dependencies") {
            let viewController: SearchViewController = self.loadUI(storyboard: "Search")
            expect(viewController).toEventuallyNot(beNil())
            expect(viewController.presenter).toNot(beNil())
        }
    }
}

import Nimble
import Quick
@testable import zomato
