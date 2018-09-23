//
//  MockStorageClient.swift
//  Specs
//
//  Created by Harry on 24/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

final class MockStorageClient: Storage {
    private(set) var store: Data?
    private(set) var storeItemName: String?

    func store(_ item: Data, named: String) throws {
        store = item
        storeItemName = named
    }

    var retrive: Data?
    private(set) var retriveItemName: String?

    func retrive(itemNamed name: String) throws -> Data? {
        retriveItemName = name
        return retrive
    }

    private(set) var invalidateCalled: Bool = false
    private(set) var invalidateCalledCount: Int = 0

    func invalidate() throws {
        invalidateCalled = true
        invalidateCalledCount += 1
    }
}

import Foundation
@testable import zomato
