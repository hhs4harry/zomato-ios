//
//  StorageClientSpec.swift
//  Specs
//
//  Created by Harry on 24/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

final class StorageClientSpec: QuickSpec {
    var client: Storage?
    var baseURL: URL!

    override func spec() {
        describe("a StorageClient") {
            beforeEach {
                self.baseURL = try? FileManager.default.url(
                    for: .cachesDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: false
                ).appendingPathComponent("zomato")
                self.client = StorageClient()
            }

            afterEach {
                self.client = nil
            }

            self.resolve()
            self.store()
            self.retrive()
            self.invalidate()
        }
    }

    func resolve() {
        it("resolves") {
            let client: Storage? = Dependencies.container.resolve(Storage.self)
            expect(client).toNot(beNil())
        }
    }

    func store() {
        context("its store") {
            beforeEach {
                try? self.client?.store(Data(), named: "config")
            }

            afterEach {
                try? FileManager.default.removeItem(at: self.baseURL.appendingPathComponent("config"))
            }

            it("stores an item") {
                expect(FileManager.default.fileExists(atPath: self.baseURL.appendingPathComponent("config").path)).to(beTrue())
            }

            context("its override") {
                it("overrides an item if store is called with the same name") {
                    do {
                        let data: Data = "old".data(using: .utf8) ?? Data()
                        let newData: Data = "new".data(using: .utf8) ?? Data()

                        try self.client?.store(data, named: "config")

                        let oldData: Data? = try self.client?.retrive(itemNamed: "config")
                        let old: String? = String(data: oldData ?? Data(), encoding: .utf8)

                        try self.client?.store(newData, named: "config")

                        let newData2: Data? = try self.client?.retrive(itemNamed: "config")
                        let new: String? = String(data: newData2 ?? Data(), encoding: .utf8)

                        expect(old).to(equal("old"))
                        expect(new).to(equal("new"))
                    } catch {
                        fail("failed to initialise test")
                    }
                }
            }
        }
    }

    func retrive() {
        context("its retrive") {
            beforeEach {
                try? self.client?.store(
                    "test".data(using: .utf8)!,
                    named: "config"
                )
            }

            afterEach {
                try? FileManager.default.removeItem(at: self.baseURL.appendingPathComponent("config"))
            }

            it("retrives the stored item") {
                do {
                    let data: Data = try self.client?.retrive(itemNamed: "config") ?? Data()
                    let value: String? = String(data: data, encoding: .utf8)
                    expect(value).to(equal("test"))
                } catch {
                    fail("failed to initialise test")
                }
            }
        }
    }

    func invalidate() {
        context("its invalidate") {
            it("clears all the cache") {
                do {
                    try self.client?.store("test".data(using: .utf8)!, named: "config")
                    let data: Data? = try self.client?.retrive(itemNamed: "config")
                    try self.client?.invalidate()
                    let newData: Data? = try self.client?.retrive(itemNamed: "config")

                    expect(data).toNot(beNil())
                    expect(newData).to(beNil())
                } catch {
                    fail("failed to initialise test")
                }
            }
        }
    }
}

import Nimble
import Quick
import Swinject
@testable import zomato
