//
//  MockRouter.swift
//  Specs
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

class MockRouter: Router {
    private(set) var performSegueIdentifier: String?
    func performSegue(withIdentifier identifier: String) {
        performSegueIdentifier = identifier
    }
}

@testable import zomato
