//
//  SplashPresenter.swift
//  zomato
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

protocol SplashDisplay: Display {}
protocol SplashRouter: Router {}
protocol SplashPresenting {
    func viewDidBecomeReady()
}

final class SplashPresenter {

    // MARK: - Properties

    // MARK: Injected

    private weak var display: SplashDisplay!
    private weak var router: SplashRouter!

    // MARK: - Initialiser

    init(display: SplashDisplay, router: SplashRouter) {
        self.display = display
        self.router = router
    }
}

// MARK: - Conformance

extension SplashPresenter: SplashPresenting {
    func viewDidBecomeReady() {
        router.performSegue(withIdentifier: Routes.Splash.Search.rawValue)
    }
}

// MARK: DependencyInjectionAware

extension SplashPresenter: DependencyInjectionAware {
    static func register(in container: Container) {
        container.register(SplashPresenting.self) { _, display, router in
            SplashPresenter(display: display, router: router)
        }
        .inObjectScope(.transient)
    }
}

import Swinject
