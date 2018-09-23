//
//  SearchRequest.swift
//  zomato
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

struct SearchRequest: Request {

    // MARK: - Properties

    // MARK: Private

    private let httpMethod: HTTPMethod = .GET

    // MARK: Public

    let urlRequest: URLRequest

    // MARK: - Initiliser

    init(url: URL, apiKey: String, query: String) {
        var urlComponenets: URLComponents = URLComponents(string: url.appendingPathComponent("cities").absoluteString)!
        urlComponenets.queryItems = [URLQueryItem(name: "q", value: query)]

        var request = URLRequest(url: urlComponenets.url!)
        request.httpMethod = httpMethod.rawValue
        request.setValue(apiKey, forHTTPHeaderField: "user-key")

        urlRequest = request
    }
}

import Foundation
