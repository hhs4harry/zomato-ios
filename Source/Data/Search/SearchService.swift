//
//  SearchService.swift
//  zomato
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

final class SearchService: SearchRepository {

    // MARK: - Properties

    // MARK: Injected

    private let client: NetworkClient!
    private let endpoint: EndpointRetriving!

    // MARK: - Initialise

    init(client: NetworkClient, endpoint: EndpointRetriving) {
        self.client = client
        self.endpoint = endpoint
    }

    // MARK: - Conformance

    // MARK: SearchRepository

    func search(address: String) -> SignalProducer<[City], RepositoryError> {
        let request: SearchRequest = .init(url: endpoint.baseURL, apiKey: endpoint.apiKey, query: address)

        return (client.performTask(with: request).mapError(API.mapErrorToDomain) as SignalProducer<SearchResponse, RepositoryError>)
            .map { $0.response }
    }
}

extension SearchService: DependencyInjectionAware {
    static func register(in container: Container) {
        container.register(SearchRepository.self) { resolver in
            SearchService(client: resolver.resolve(NetworkClient.self)!, endpoint: resolver.resolve(EndpointRetriving.self)!)
        }.inObjectScope(.container)
    }
}

import ReactiveSwift
import Swinject
