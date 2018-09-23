//
//  SplashViewController.swift
//  zomato
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

final class SplashViewController: UIViewController, PresenterSource {

    // MARK: - Life Cycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presenter.viewDidBecomeReady()
    }

    // MARK: - Conformance

    // MARK: PresenterSource

    var presenter: SplashPresenting!
}

// MARK: SplashDisplay

extension SplashViewController: SplashDisplay {}

// MARK: SplashRouter

extension SplashViewController: SplashRouter {}

// MARK: DependencyInjectionAware

extension SplashViewController: DependencyInjectionAware {
    static func register(in container: Container) {
        container.storyboardInitCompleted(SplashViewController.self) { resolver, controller in
            controller.presenter = resolver.resolve(
                SplashPresenting.self,
                arguments: controller as SplashDisplay, controller as SplashRouter
            )!
        }
    }
}

import Swinject
import SwinjectStoryboard
import UIKit
