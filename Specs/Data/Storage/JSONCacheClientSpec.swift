//
//  JSONCacheClientSpec.swift
//  Specs
//
//  Created by Harry on 24/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

final class JSONCacheClientSpec: QuickSpec {
    var client: JSONCacheClient?
    var storage: MockStorageClient!

    override func spec() {
        describe("a JSONCacheClientSpec") {
            beforeEach {
                self.storage = MockStorageClient()
                self.client = JSONCacheClient(storage: self.storage)
            }

            afterEach {
                self.storage = nil
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
            let client: JSONCache? = Dependencies.container.resolve(JSONCache.self)
            expect(client).toNot(beNil())
        }
    }

    func store() {
        context("its store") {
            it("stores an item") {
                self.client?.store(
                    City(id: 123, name: "Melbourne"),
                    named: "123"
                )

                expect(self.storage.store).toNot(beNil())
                expect(self.storage.storeItemName).to(equal("123"))
            }
        }
    }

    func retrive() {
        context("its retrive") {
            beforeEach {
                self.storage.retrive = try? City(id: 123, name: "Melbourne").encode()
            }

            it("retrives the stored item") {
                let city: City? = self.client?.retrive(itemNamed: "123")
                expect(city?.name).to(equal("Melbourne"))
            }
        }
    }

    func invalidate() {
        context("its invalidate") {
            it("clears all the cache") {
                self.client?.invalidate()

                expect(self.storage.invalidateCalled).to(beTrue())
                expect(self.storage.invalidateCalledCount).to(equal(1))
            }
        }
    }
}

import Nimble
import Quick
import Swinject
@testable import zomato
