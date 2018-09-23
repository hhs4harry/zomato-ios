//
//  Restaurant.swift
//  zomato
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

struct Restaurant: Codable {
    struct Location: Codable {
        let address: String
    }

    struct Rating: Codable {
        let aggregate: String

        enum CodingKeys: String, CodingKey {
            case aggregate = "aggregate_rating"
        }
    }

    let name: String
    let location: Location
    let image: URL
    let rating: Rating

    enum CodingKeys: String, CodingKey {
        case name
        case location
        case image = "featured_image"
        case rating = "user_rating"
    }
}

import Foundation
