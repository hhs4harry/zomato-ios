//
//  MockSearchUseCase.swift
//  Specs
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

final class MockSearchUseCase: SearchUseCase {
    var result: [City]?
    var error: RepositoryError?

    private(set) var address: String?
    func search(address: String) -> SignalProducer<[City], RepositoryError> {
        self.address = address

        if let error = error {
            return .init(error: error)
        }

        return .init(value: result!)
    }
}

import ReactiveSwift
@testable import zomato
