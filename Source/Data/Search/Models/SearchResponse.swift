//
//  SearchResponse.swift
//  zomato
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

struct SearchResponse: Codable {
    let response: [City]

    enum CodingKeys: String, CodingKey {
        case response = "location_suggestions"
    }
}
