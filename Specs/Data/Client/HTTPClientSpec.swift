//
//  HTTPClientSpec.swift
//  Specs
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

final class HTTPClientSpec: QuickSpec {
    var session: MockURLSession!
    var request: MockRequest!
    var client: NetworkClient!
    var disposable: Disposable?

    override func spec() {
        describe("a HTTPClient") {
            beforeEach {
                self.session = MockURLSession()
                self.request = MockRequest(urlRequest: URLRequest(url: URL(string: "www.example.com")!))
                self.client = HTTPClient(session: self.session)
            }

            afterEach {
                self.disposable?.dispose()
                self.client = nil
                self.session = nil
                self.request = nil
            }

            self.resolve()
            self.noNetwork()
            self.timeout()
            self.unexpected()
            self.responseType()
            self.success()
        }
    }

    func resolve() {
        it("resolves") {
            let resolvedClient: NetworkClient? = Dependencies.container.resolve(NetworkClient.self)
            expect(resolvedClient).toNot(beNil())
        }
    }

    func noNetwork() {
        context("when there is no network") {
            beforeEach {
                self.session.error = NSError(
                    domain: "sonarr.httpclient.error.spec",
                    code: NSURLErrorNotConnectedToInternet, userInfo: nil
                )
            }

            afterEach {
                self.session.error = nil
            }

            it("returns a no network error") {
                var error: API?

                let task: SignalProducer<Response, API> = self.client.performTask(with: self.request)

                self.disposable = task.startWithFailed { error = $0 }

                expect(error).toEventually(equal(.noNetwork))
            }
        }
    }

    func timeout() {
        context("when it timesout") {
            beforeEach {
                self.session.error = NSError(domain: "sonarr.httpclient.error.spec", code: NSURLErrorTimedOut, userInfo: nil)
            }

            afterEach {
                self.session.error = nil
            }

            it("returns a timeout error") {
                var error: API?

                let task: SignalProducer<Response, API> = self.client.performTask(with: self.request)

                self.disposable = task.startWithFailed { error = $0 }

                expect(error).toEventually(equal(.timeout))
            }
        }
    }

    func unexpected() {
        context("when the error code is not caught") {
            beforeEach {
                self.session.error = NSError(domain: "sonarr.httpclient.error.spec", code: 451, userInfo: nil)
            }

            afterEach {
                self.session.error = nil
            }

            it("returns a timeout error") {
                var error: API?
                let task: SignalProducer<Response, API> = self.client.performTask(with: self.request)

                self.disposable = task.startWithFailed { error = $0 }

                expect(error)
                    .toEventually(equal(.unexpected(NSError(domain: "sonarr.httpclient.error.spec", code: 451, userInfo: nil))))
            }
        }
    }

    func responseType() {
        context("when the response is not an http response type") {
            beforeEach {
                self.session.response = URLResponse(
                    url: URL(string: "www.example.com")!,
                    mimeType: nil,
                    expectedContentLength: 0,
                    textEncodingName: nil
                )
            }

            afterEach {
                self.session.response = nil
            }

            it("returns a timeout error") {
                var error: API?
                let task: SignalProducer<Response, API> = self.client.performTask(with: self.request)

                self.disposable = task.startWithFailed { error = $0 }

                expect(error).toEventually(equal(.unexpectedResponseType))
            }
        }
    }
}

private extension HTTPClientSpec {
    private func noData() {
        context("when no data is returned") {
            beforeEach {
                self.session.result = nil
            }

            it("returns a empty error") {
                var error: API?
                let task: SignalProducer<Response, API> = self.client.performTask(with: self.request)

                self.disposable = task.startWithFailed { error = $0 }

                expect(error).toEventually(equal(.empty))
            }
        }
    }

    private func decoderFail() {
        context("when the decoder fails") {
            beforeEach {
                self.session.result = "".data(using: .utf8)
            }

            it("returns a conversion error") {
                var error: API?
                let task: SignalProducer<Response, API> = self.client.performTask(with: self.request)

                self.disposable = task.startWithFailed { error = $0 }

                expect(error).toEventually(equal(.conversionFailure))
            }
        }
    }

    private func decoderSuccess() {
        context("when the decoder succeeds") {
            beforeEach {
                self.session.result = " { \"value\": \"success\" } ".data(using: .utf8)
            }

            it("returns a response") {
                var response: Response?
                let task: SignalProducer<Response, API> = self.client.performTask(with: self.request)

                self.disposable = task.startWithResult { response = $0.value }

                expect(response?.value).toEventually(equal("success"))
            }
        }
    }

    private func responseCodeRange() {
        context("when the response code is not in the success range") {
            beforeEach {
                self.session.response = HTTPURLResponse(
                    url: URL(string: "www.example.com")!,
                    statusCode: 500,
                    httpVersion: nil,
                    headerFields: nil
                )
            }

            it("returns a server error") {
                var error: API?
                let task: SignalProducer<Response, API> = self.client.performTask(with: self.request)

                self.disposable = task.startWithFailed { error = $0 }

                expect(error).toEventually(equal(.server(status: 500)))
            }
        }
    }

    func success() {
        context("when a successful response is returned") {
            beforeEach {
                self.session.response = HTTPURLResponse(
                    url: URL(string: "www.example.com")!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: nil
                )
            }

            self.noData()
            self.decoderFail()
            self.decoderSuccess()
            self.responseCodeRange()
        }
    }
}

// MARK: - Helpers

private struct Response: Decodable {
    let value: String
}

import Nimble
import Quick
import ReactiveSwift
import Result
import Swinject
@testable import zomato
