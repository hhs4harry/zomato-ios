//
//  SplashPresenterSpec.swift
//  Specs
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

final class MockSplashDisplay: MockDisplay, SplashDisplay {}

final class MockSplashRouter: MockRouter, SplashRouter {}

final class SplashPresenterSpec: QuickSpec {
    var presenter: SplashPresenter!
    var display: MockSplashDisplay!
    var router: MockSplashRouter!

    override func spec() {
        describe("a SplashPresenter") {
            beforeEach {
                self.display = MockSplashDisplay()
                self.router = MockSplashRouter()
                self.presenter = SplashPresenter(display: self.display, router: self.router)
            }

            afterEach {
                self.presenter = nil
            }

            it("resolves its dependencies") {
                let viewController: SplashViewController = self.loadUI(storyboard: "Splash")
                expect(viewController).toEventuallyNot(beNil())
                expect(viewController.presenter).toNot(beNil())
            }

            it("routes to search") {
                self.presenter.viewDidBecomeReady()

                expect(self.router.performSegueIdentifier).to(equal("Search"))
            }
        }
    }
}

import Nimble
import Quick
@testable import zomato
