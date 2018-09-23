//
//  SearchPresenter.swift
//  zomato
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

protocol SearchDisplay: Display {
    func set(placeholder: String)
    func show(results: [Result])
}

protocol SearchRouter: Router {}
protocol SearchPresenting {
    var searchValue: MutableProperty<String?> { get }
    func viewDidBecomeReady()
    func inject(presenter: RestaurantsInjectable)
}

final class SearchPresenter: SearchPresenting {

    // MARK: - Properties

    // MARK: Private

    private let disposable: CompositeDisposable = .init()
    private let results: MutableProperty<[City]> = .init([])
    private var city: City!

    // MARK: Injected

    private weak var display: SearchDisplay!
    private weak var router: SearchRouter!
    private let searchUseCase: SearchUseCase!

    // MARK: - Initialiser

    init(display: SearchDisplay, router: SearchRouter, searchUseCase: SearchUseCase) {
        self.display = display
        self.router = router
        self.searchUseCase = searchUseCase
    }

    deinit {
        disposable.dispose()
    }

    // MARK: - Helpers

    func configureBindings() {
        disposable += searchValue.producer
            .skipNil()
            .skipRepeats()
            .skip(while: { $0.count == 0 })
            .throttle(0.2, on: QueueScheduler.main)
            .flatMap(.latest) { [unowned self] query -> SignalProducer<[City], NoError> in
                self.searchUseCase.search(address: query).flatMapError { _ in SignalProducer.empty }
            }
            .observe(on: QueueScheduler.main)
            .startWithValues { [unowned self] results in
                self.results.value = results
            }

        disposable += results.producer
            .map { $0.map { [unowned self] in Result(title: $0.name, action: self.action(forResult: $0)) } }
            .observe(on: QueueScheduler.main)
            .startWithValues { [unowned self] results in
                self.display.show(results: results)
            }
    }

    func action(forResult city: City) -> ButtonAction {
        return { [unowned self] in
            self.city = city
            self.router.performSegue(withIdentifier: Routes.Search.Restaurants.rawValue)
        }
    }

    // MARK: - Conformance

    // MARK: SearchPresenting

    let searchValue: MutableProperty<String?> = .init("")

    func viewDidBecomeReady() {
        configureBindings()
        display.set(placeholder: "Enter location e.g Melbourne, Australia")
    }

    func inject(presenter: RestaurantsInjectable) {
        presenter.inject(city: city)
    }
}

// MARK: DependencyInjectionAware

extension SearchPresenter: DependencyInjectionAware {
    static func register(in container: Container) {
        container.register(SearchPresenting.self) { resolver, display, router in
            SearchPresenter(display: display, router: router, searchUseCase: resolver.resolve(SearchUseCase.self)!)
        }
        .inObjectScope(.transient)
    }
}

import ReactiveCocoa
import ReactiveSwift
import enum Result.NoError
import Swinject
