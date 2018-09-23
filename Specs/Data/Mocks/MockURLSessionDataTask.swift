//
//  MockURLSessionDataTask.swift
//  Specs
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

final class MockURLSessionDataTask: URLSessionDataTask {
    let resumeAction: () -> Void

    init(resumeAction: @escaping () -> Void) {
        self.resumeAction = resumeAction
    }

    override func resume() {
        resumeAction()
    }

    override func cancel() {}
}

import Foundation
@testable import zomato
