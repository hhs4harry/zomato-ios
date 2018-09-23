//
//  Decodable+Decode.swift
//  zomato
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

extension Decodable {
	private static var decoder: JSONDecoder { return .init() }

	static func decode(fromJSONData data: Data) throws -> Self {
		return try decoder.decode(self, from: data)
	}
}

import Foundation
