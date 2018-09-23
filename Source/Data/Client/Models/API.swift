//
//  API.swift
//  zomato
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

enum API: Error {
    case noNetwork
    case timeout
    case empty
    case unexpectedResponseType
    case unexpected(Error)
    case server(status: Int)
    case conversionFailure
}

// MARK: - Conformance

// MARK: Equatable

extension API: Equatable {
    public static func == (lhs: API, rhs: API) -> Bool {
        switch (lhs, rhs) {
        case (.noNetwork, .noNetwork): return true
        case (.timeout, .timeout): return true
        case (.empty, .empty): return true
        case (.unexpectedResponseType, .unexpectedResponseType): return true
        case (.unexpected(_), .unexpected(_)): return true
        case let (.server(lhs), .server(rhs)): return lhs == rhs
        case (.conversionFailure, .conversionFailure): return true
        default: return false
        }
    }
}

extension API {
    static let mapErrorToDomain: (API) -> RepositoryError = { error in
        switch error {
        case .noNetwork: return .noNetwork
        case .timeout: return .timeout
        default: return .general
        }
    }
}

import Foundation
import Result
