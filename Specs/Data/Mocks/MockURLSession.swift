//
//  MockURLSession.swift
//  Specs
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

final class MockURLSession: URLSession {
	var error: Error?
	var result: Data?
	var response: URLResponse?
	var request: URLRequest?

	override func dataTask(
		with request: URLRequest,
		completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
		) -> URLSessionDataTask {
		self.request = request
		let task: MockURLSessionDataTask = .init(
			resumeAction: { [unowned self] in
				completionHandler(self.result, self.response, self.error)
			}
		)
		return task
	}
}

import Foundation
@testable import zomato
