//
//  RestaurantsPresenter.swift
//  zomato
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

protocol RestaurantsDisplay: Display {
    func show(restaurants: [RestaurantItem])
}

protocol RestaurantsRouter: Router {}
protocol RestaurantsPresenting {
    func viewDidBecomeReady()
}
protocol RestaurantsInjectable {
    func inject(city: City)
}

final class RestaurantsPresenter: RestaurantsPresenting {

    // MARK: - Properties

    // MARK: Injected

    private weak var display: RestaurantsDisplay!
    private weak var router: RestaurantsRouter!
    private let restaurantsUseCase: RestaurantsUseCase
    private let imageUseCase: ImageUseCase
    private var city: City!

    // MARK: Private

    private let disposables: CompositeDisposable = .init()

    // MARK: - Initialiser

    init(display: RestaurantsDisplay, router: RestaurantsRouter, restaurantsUseCase: RestaurantsUseCase, imageUseCase: ImageUseCase) {
        self.display = display
        self.router = router
        self.restaurantsUseCase = restaurantsUseCase
        self.imageUseCase = imageUseCase
    }

    // MARK: - Helpers

    private func image(url: URL) -> SignalProducer<UIImage?, NoError> {
        print(url.absoluteURL.absoluteString)
        return imageUseCase.load(image: url).observe(on: QueueScheduler.main)
    }

    private func fetchRestaurants(forCity city: City) {
        disposables += restaurantsUseCase.bestRestaurants(forCity: city)
            .map { [unowned self] in
                $0.map { RestaurantItem(image: self.image(url: $0.image), title: $0.name, subTitle: $0.location.address) }
            }
            .observe(on: QueueScheduler.main)
            .on(
                value: { [unowned self] restaurants in
                    self.display.show(restaurants: restaurants)
                }
            ).start()
    }

    // MARK: - Conformance

    // MARK: RestaurantsPresenting

    func viewDidBecomeReady() {
        fetchRestaurants(forCity: city)
    }
}

// MARK: RestaurantsInjectable

extension RestaurantsPresenter: RestaurantsInjectable {
    func inject(city: City) {
        self.city = city
    }
}

// MARK: DependencyInjectionAware

extension RestaurantsPresenter: DependencyInjectionAware {
    static func register(in container: Container) {
        container.register(RestaurantsPresenting.self) { resolver, display, router in
            RestaurantsPresenter(
                display: display,
                router: router,
                restaurantsUseCase: resolver.resolve(RestaurantsUseCase.self)!,
                imageUseCase: resolver.resolve(ImageUseCase.self)!
            )
        }
        .inObjectScope(.transient)
    }
}
import ReactiveSwift
import enum Result.NoError
import Swinject
import UIKit
