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

    // MARK: - Properties

    // MARK: Injected

    private let repository: ImageRepository
    private let imageCache: ImageCache

    // MARK: - Initialise

    init(repository: ImageRepository, imageCache: ImageCache) {
        self.repository = repository
        self.imageCache = imageCache
    }

    // MARK: - Conformance

    // MARK: ImageUseCase

    func load(image: URL) -> SignalProducer<UIImage?, NoError> {
        return SignalProducer { [unowned self] observer, lifetime in
            if let cache = self.imageCache.retrive(imageNamed: image.absoluteString) {
                observer.send(value: cache)
                observer.sendCompleted()
            } else {
                let disposable: Disposable = self.repository.load(image: image)
                    .on(
                        failed: { _ in
                            observer.send(value: nil)
                            observer.sendCompleted()
                        },
                        value: { result in
                            if let result = result {
                                self.imageCache.store(image: result, named: image.absoluteString)
                            }
                            observer.send(value: result)
                            observer.sendCompleted()
                        }
                    ).start()

                lifetime.observeEnded {
                    disposable.dispose()
                }
            }
        }
    }
}

// MARK: DependencyInjectionAware

extension ImageUseCaseImplementation: DependencyInjectionAware {
    static func register(in container: Container) {
        container.register(ImageUseCase.self) { resolver in
            ImageUseCaseImplementation(
                repository: resolver.resolve(ImageRepository.self)!,
                imageCache: resolver.resolve(ImageCache.self)!
            )
        }.inObjectScope(.transient)
    }
}

import ReactiveSwift
import enum Result.NoError
import Swinject
import UIKit
