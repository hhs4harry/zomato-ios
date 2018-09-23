//
//  ImageCacheClient.swift
//  zomato
//
//  Created by Harry on 24/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

final class ImageCacheClient: ImageCache {

    // MARK: - Properties

    // MARK: Private

    private let storage: Storage
    private let cache: NSCache<NSString, UIImage> = .init()

    // MARK: - Initialise

    init(storage: Storage) {
        self.storage = storage
    }

    // MARK: - Conformance

    // MARK: ImageCache

    func store(image: UIImage, named: String) {
        cache.setObject(image, forKey: NSString(string: named))

        do {
            guard let data = UIImageJPEGRepresentation(image, 1.0) else { return }
            try storage.store(data, named: named)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func retrive(imageNamed name: String) -> UIImage? {
        if let image = cache.object(forKey: NSString(string: name)) {
            return image
        }

        do {
            guard let data = try storage.retrive(itemNamed: name), let image = UIImage(data: data) else { return nil }
            cache.setObject(image, forKey: NSString(string: name))
            return image
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

// MARK: DependencyInjectionAware

extension ImageCacheClient: DependencyInjectionAware {
    static func register(in container: Container) {
        container.register(ImageCache.self) { ImageCacheClient(storage: $0.resolve(Storage.self)!) }
    }
}

import Foundation
import Swinject
import UIKit.UIImage
