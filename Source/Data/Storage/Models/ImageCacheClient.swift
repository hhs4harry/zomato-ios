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
        cache.setObject(image, forKey: NSString(string: named.encoded))

        do {
            guard let data = UIImageJPEGRepresentation(image, 1.0) else { return }
            try storage.store(data, named: named.encoded)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func retrive(imageNamed name: String) -> UIImage? {
        if let image = cache.object(forKey: NSString(string: name.encoded)) {
            return image
        }

        do {
            guard let data = try storage.retrive(itemNamed: name.encoded), let image = UIImage(data: data) else { return nil }
            cache.setObject(image, forKey: NSString(string: name.encoded))
            return image
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

private extension String {
    var encoded: String {
        return md5
    }
}

// MARK: DependencyInjectionAware

extension ImageCacheClient: DependencyInjectionAware {
    static func register(in container: Container) {
        container.register(ImageCache.self) { ImageCacheClient(storage: $0.resolve(Storage.self)!) }.inObjectScope(.container)
    }
}

import Foundation
import Swinject
import UIKit.UIImage
