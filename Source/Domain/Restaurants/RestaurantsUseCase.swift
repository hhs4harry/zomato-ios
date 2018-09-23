//
//  RestaurantsUseCase.swift
//  zomato
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

protocol RestaurantsUseCase {
    func bestRestaurants(forCity city: City) -> SignalProducer<[Restaurant], RepositoryError>
}

final class RestaurantsUseCaseImplementation: RestaurantsUseCase {

    // MARK: - Properties

    // MARK: Private

    private let repository: RestaurantsRepository
    private let cacheClient: JSONCache

    // MARK: Initialise

    init(repository: RestaurantsRepository, cacheClient: JSONCache) {
        self.repository = repository
        self.cacheClient = cacheClient
    }

    // MARK: - Conformance

    // MARK: RestaurantsUseCase

    func bestRestaurants(forCity city: City) -> SignalProducer<[Restaurant], RepositoryError> {
        return SignalProducer<[Restaurant], RepositoryError> { [unowned self] observer, lifetime in
            let cacheKey: String = "\(city.name)_\(String(city.id))"
            if let cache: [Restaurant] = self.cacheClient.retrive(itemNamed: cacheKey) {
                observer.send(value: cache)
            }

            let disposable: Disposable = self.repository.bestRestaurants(forCity: city)
                .on(
                    failed: { _ in
                        observer.sendCompleted()
                    },
                    value: { result in
                        self.cacheClient.store(result, named: cacheKey)
                        observer.send(value: result)
                        observer.sendCompleted()
                    }
                )
                .start()

            lifetime.observeEnded {
                disposable.dispose()
            }
        }
        .map { $0.sorted(by: { Double($0.rating.aggregate) ?? 0.0 > Double($1.rating.aggregate) ?? 0.0 }) }
    }
}

// MARK: DependencyInjectionAware

extension RestaurantsUseCaseImplementation: DependencyInjectionAware {
    static func register(in container: Container) {
        container.register(RestaurantsUseCase.self) { resolver in
            RestaurantsUseCaseImplementation(
                repository: resolver.resolve(RestaurantsRepository.self)!,
                cacheClient: resolver.resolve(JSONCache.self)!
            )
        }.inObjectScope(.transient)
    }
}

import ReactiveSwift
import Swinject
