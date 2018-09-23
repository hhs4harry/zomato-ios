//
//  SearchUseCase.swift
//  zomato
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

protocol SearchUseCase {
    func search(address: String) -> SignalProducer<[City], RepositoryError>
}

final class SearchUseCaseImplementation: SearchUseCase {
    private let repository: SearchRepository!

    init(repository: SearchRepository) {
        self.repository = repository
    }

    func search(address: String) -> SignalProducer<[City], RepositoryError> {
        return repository.search(address: address)
    }
}

extension SearchUseCaseImplementation: DependencyInjectionAware {
    static func register(in container: Container) {
        container.register(SearchUseCase.self) { resolver in
            SearchUseCaseImplementation(repository: resolver.resolve(SearchRepository.self)!)
        }.inObjectScope(.transient)
    }
}

import ReactiveSwift
import Swinject
