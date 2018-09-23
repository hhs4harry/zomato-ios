//
//  Segue.swift
//  zomato
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

protocol Segue {
    func performSegue(withIdentifier identifier: String)
}

extension Segue where Self: UIViewController {
    func performSegue(withIdentifier identifier: String) {
        performSegue(withIdentifier: identifier, sender: self)
    }
}

import UIKit
