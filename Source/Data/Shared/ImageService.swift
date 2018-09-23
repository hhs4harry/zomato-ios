//
//  ImageService.swift
//  zomato
//
//  Created by Harry on 24/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

final class ImageService: ImageRepository {

    // MARK: - Properties

    // MARK: Private

    private let session: URLSession

    // MARK: Initialise

    init(session: URLSession) {
        self.session = session
    }

    // MARK: - Conformance

    // MARK: ImageRepository

    func load(image: URL) -> SignalProducer<UIImage?, NoError> {
        return SignalProducer<UIImage?, NoError> { [unowned self] observer, lifetime in
            let task: URLSessionDataTask = self.session.dataTask(with: image) { data, _, _ in
                if let data = data {
                    observer.send(value: UIImage(data: data))
                } else {
                    observer.send(value: nil)
                }

                observer.sendCompleted()
            }

            task.resume()

            lifetime.observeEnded {
                task.cancel()
            }
        }
    }
}

// MARK: DependencyInjectionAware

extension ImageService: DependencyInjectionAware {
    static func register(in container: Container) {
        container.register(ImageRepository.self) { _ in ImageService(session: .shared) }.inObjectScope(.container)
    }
}

import ReactiveSwift
import enum Result.NoError
import Swinject
import UIKit
