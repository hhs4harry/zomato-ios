//
//  Storage.swift
//  zomato
//
//  Created by Harry on 24/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

protocol Storage {
    func store(_ item: Data, named: String) throws
    func retrive(itemNamed name: String) throws -> Data?
    func invalidate() throws
}

import Foundation
