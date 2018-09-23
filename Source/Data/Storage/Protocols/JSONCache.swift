//
//  JSONCache.swift
//  zomato
//
//  Created by Harry on 24/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

protocol JSONCache {
    func store<T: Encodable>(_ item: T, named: String)
    func retrive<T: Decodable>(itemNamed name: String) -> T?
    func invalidate()
}

import Foundation
