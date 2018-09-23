//
//  Endpoint.swift
//  zomato
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

protocol EndpointRetriving {
    var baseURL: URL { get }
    var apiKey: String { get }
}

struct Endpoint: EndpointRetriving {
    let baseURL: URL = URL(string: "https://developers.zomato.com/api/v2.1/")!
    let apiKey: String = ""
}

extension Endpoint: DependencyInjectionAware {
    static func register(in container: Container) {
        container.register(EndpointRetriving.self) { _ in Endpoint() }.inObjectScope(.transient)
    }
}

import Foundation
import Swinject
