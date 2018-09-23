//
//  RestaurantsService.swift
//  zomato
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

final class RestaurantsService: RestaurantsRepository {

    // MARK: - Properties

    // MARK: Injected

    private let client: NetworkClient
    private let endpoint: EndpointRetriving

    // MARK: Initialise

    init(client: NetworkClient, endpoint: EndpointRetriving) {
        self.client = client
        self.endpoint = endpoint
    }

    // MARK: - Conformance

    // MARK: RestaurantsRepository

    func bestRestaurants(forCity city: City) -> SignalProducer<[Restaurant], RepositoryError> {
        let request: RestaurantsRequest = .init(url: endpoint.baseURL, apiKey: endpoint.apiKey, id: city.id)

        return (client.performTask(with: request)
            .mapError(API.mapErrorToDomain) as SignalProducer<RestaurantResponse, RepositoryError>)
            .map { $0.restaurants.map { $0.restaurant } }
    }
}

// MARK: DependencyInjectionAware

extension RestaurantsService: DependencyInjectionAware {
    static func register(in container: Container) {
        container.register(RestaurantsRepository.self) { resolver in
            RestaurantsService(client: resolver.resolve(NetworkClient.self)!, endpoint: resolver.resolve(EndpointRetriving.self)!)
        }.inObjectScope(.container)
    }
}

import ReactiveSwift
import Swinject
