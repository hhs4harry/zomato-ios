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

    // MARK: Initialise

    init(repository: RestaurantsRepository) {
        self.repository = repository
    }

    // MARK: - Conformance

    // MARK: RestaurantsUseCase

    func bestRestaurants(forCity city: City) -> SignalProducer<[Restaurant], RepositoryError> {
        return repository.bestRestaurants(forCity: city)
            .map { $0.sorted(by: { Double($0.rating.aggregate) ?? 0.0 > Double($1.rating.aggregate) ?? 0.0 }) }
    }
}

// MARK: DependencyInjectionAware

extension RestaurantsUseCaseImplementation: DependencyInjectionAware {
    static func register(in container: Container) {
        container.register(RestaurantsUseCase.self) { resolver in
            RestaurantsUseCaseImplementation(repository: resolver.resolve(RestaurantsRepository.self)!)
        }.inObjectScope(.transient)
    }
}

import ReactiveSwift
import Swinject
