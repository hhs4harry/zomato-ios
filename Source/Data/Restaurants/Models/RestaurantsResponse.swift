//
//  RestaurantsResponse.swift
//  zomato
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

struct RestaurantResponse: Codable {
    struct RestaurantEnclosure: Codable {
        let restaurant: Restaurant
    }

    let restaurants: [RestaurantEnclosure]
}
