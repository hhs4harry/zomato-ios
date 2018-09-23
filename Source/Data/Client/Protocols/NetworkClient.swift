//
//  NetworkClient.swift
//  zomato
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

protocol NetworkClient {
    @discardableResult func performTask<T: Decodable>(with request: Request) -> SignalProducer<T, API>
}

import Foundation
import ReactiveSwift
