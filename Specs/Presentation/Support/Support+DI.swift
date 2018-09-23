//
//  Support+DI.swift
//  Specs
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

extension QuickSpec {
    func loadUI<T>(storyboard named: String, controller identifier: String = String(describing: T.self)) -> T {
        return UIStoryboard(name: named, bundle: .main)
            .instantiateViewController(withIdentifier: identifier) as! T
    }
}

import Nimble
import Quick
@testable import zomato
