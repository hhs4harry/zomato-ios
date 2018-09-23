//
//  RestaurantsRequest.swift
//  zomato
//
//  Created by Harry on 24/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

struct RestaurantsRequest: Request {
    enum Entity: String {
        case city
    }

    enum Sort: String {
        case rating
    }

    // MARK: - Properties

    // MARK: Private

    private let httpMethod: HTTPMethod = .GET

    // MARK: Initialise

    init(url: URL, apiKey: String, id: Int, entity: Entity = .city, sort: Sort = .rating, resultCount: Int = 10) {
        var urlComponenets: URLComponents = URLComponents(string: url.appendingPathComponent("search").absoluteString)!
        urlComponenets.queryItems = [
            URLQueryItem(name: "entity_type", value: entity.rawValue),
            URLQueryItem(name: "entity_id", value: String(id)),
            URLQueryItem(name: "sort", value: sort.rawValue),
            URLQueryItem(name: "count", value: String(resultCount)),
        ]

        var request = URLRequest(url: urlComponenets.url!)
        request.httpMethod = httpMethod.rawValue
        request.setValue(apiKey, forHTTPHeaderField: "user-key")

        urlRequest = request
    }

    // MARK: - Conformance

    // MARK: Request

    var urlRequest: URLRequest
}

import Foundation
