//
//  String+Dequeue.swift
//  zomato
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

extension String {
    func loadFromStoryboard<T>() -> T {
        return UIStoryboard(name: self, bundle: .main).instantiateInitialViewController() as! T
    }
}

import UIKit
