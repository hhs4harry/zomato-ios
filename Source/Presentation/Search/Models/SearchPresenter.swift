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
}

final class SearchPresenter: SearchPresenting {

    // MARK: - Properties

    // MARK: Private

    private let disposable: CompositeDisposable = .init()

    // MARK: Injected

    private weak var display: SearchDisplay!
    private weak var router: SearchRouter!

    // MARK: - Initialiser

    init(display: SearchDisplay, router: SearchRouter) {
        self.display = display
        self.router = router

        configureBindings()
    }

    // MARK: - Helpers

    func configureBindings() {
        disposable += searchValue.producer.skipNil().skipRepeats().throttle(0.5, on: QueueScheduler.main).startWithValues { values in
            print(values)
        }
    }

    // MARK: - Conformance

    // MARK: SearchPresenting

    let searchValue: MutableProperty<String?> = .init("")

    func viewDidBecomeReady() {
        display.set(placeholder: "Enter location e.g Melbourne, Australia")
    }
}

// MARK: DependencyInjectionAware

extension SearchPresenter: DependencyInjectionAware {
    static func register(in container: Container) {
        container.register(SearchPresenting.self) { _, display, router in
            SearchPresenter(display: display, router: router)
        }
        .inObjectScope(.transient)
    }
}
import ReactiveCocoa
import ReactiveSwift
import Swinject
