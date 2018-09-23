//
//  ImageUseCase.swift
//  zomato
//
//  Created by Harry on 24/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

protocol ImageUseCase {
    func load(image: URL) -> SignalProducer<UIImage?, NoError>
}

final class ImageUseCaseImplementation: ImageUseCase {
    private let repository: ImageRepository

    init(repository: ImageRepository) {
        self.repository = repository
    }

    // MARK: - Conformance

    // MARK: ImageUseCase

    func load(image: URL) -> SignalProducer<UIImage?, NoError> {
        return repository.load(image: image)
    }
}

// MARK: DependencyInjectionAware

extension ImageUseCaseImplementation: DependencyInjectionAware {
    static func register(in container: Container) {
        container.register(ImageUseCase.self) { resolver in
            ImageUseCaseImplementation(repository: resolver.resolve(ImageRepository.self)!)
        }.inObjectScope(.transient)
    }
}

import ReactiveSwift
import enum Result.NoError
import Swinject
import UIKit
