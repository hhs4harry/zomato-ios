//
//  JSONCacheClient.swift
//  zomato
//
//  Created by Harry on 24/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

final class JSONCacheClient: JSONCache {

    // MARK: - Properties

    // MARK: Private

    private let storage: Storage

    // MARK: - Initialise

    init(storage: Storage) {
        self.storage = storage
    }

    // MARK: - Conformance

    // MARK: JSONCache

    func store<T: Encodable>(_ item: T, named: String) {
        do {
            let data: Data = try item.encode()
            try storage.store(data, named: named)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func retrive<T: Decodable>(itemNamed name: String) -> T? {
        do {
            guard let data = try storage.retrive(itemNamed: name) else { return nil }
            let model = try T.decode(fromJSONData: data)
            return model
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func invalidate() {
        try! storage.invalidate()
    }
}

// MARK: DependencyInjectionAware

extension JSONCacheClient: DependencyInjectionAware {
    static func register(in container: Container) {
        container.register(JSONCache.self) { JSONCacheClient(storage: $0.resolve(Storage.self)!) }
    }
}

import Foundation
import Swinject
