//
//  Encodable+Encode.swift
//  zomato
//
//  Created by Harry on 24/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

extension Encodable {
    private var encoder: JSONEncoder { return .init() }

    func encode() throws -> Data {
        return try encoder.encode(self)
    }
}

import Foundation
