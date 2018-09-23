//
//  HTTPClient.swift
//  zomato
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

final class HTTPClient {

    // MARK: - Properties

    private let session: URLSession

    // MARK: - Initialiser

    init(session: URLSession) {
        self.session = session
    }

    // MARK: - Helpers

    private func handleTaskError<T: Decodable>(error: Error, observer: Signal<T, API>.Observer) {
        let networkError: NSError = error as NSError

        switch networkError.code {
        case NSURLErrorNotConnectedToInternet:
            observer.send(error: .noNetwork)

        case NSURLErrorTimedOut:
            observer.send(error: .timeout)

        default:
            observer.send(error: .unexpected(networkError))
        }
    }

    private func handleTaskResponse<T: Decodable>(response: URLResponse?, data: Data?, observer: Signal<T, API>.Observer) {
        guard let response = response as? HTTPURLResponse else {
            observer.send(error: .unexpectedResponseType)
            return
        }

        if 200 ... 299 ~= response.statusCode {
            handleDecode(data: data, observer: observer)
        } else {
            observer.send(error: .server(status: response.statusCode))
        }
    }

    private func handleDecode<T: Decodable>(data: Data?, observer: Signal<T, API>.Observer) {
        guard let data = data else {
            observer.send(error: .empty)
            return
        }

        do {
            let response: T = try T.decode(fromJSONData: data)
            observer.send(value: response)
            observer.sendCompleted()
        } catch {
            observer.send(error: .conversionFailure)
        }
    }
}

// MARK: - Conformance

// MARK: NetworkClient

extension HTTPClient: NetworkClient {
    func performTask<T: Decodable>(with request: Request) -> SignalProducer<T, API> {
        return .init { [unowned self] observer, lifetime in
            let task: URLSessionDataTask = self.session.dataTask(with: request.urlRequest) { data, response, error in
                if let error = error {
                    self.handleTaskError(error: error, observer: observer)
                } else {
                    self.handleTaskResponse(response: response, data: data, observer: observer)
                }
            }

            task.resume()

            lifetime.observeEnded {
                task.cancel()
            }
        }
    }
}

// MARK: DependencyInjectionAware

extension HTTPClient: DependencyInjectionAware {
    static func register(in container: Container) {
        container.register(NetworkClient.self) { _ in HTTPClient(session: .init()) }.inObjectScope(.transient)
    }
}

import Foundation
import ReactiveSwift
import Result
import Swinject
