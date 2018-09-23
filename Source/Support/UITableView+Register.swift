//
//  UITableView+Register.swift
//  zomato
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

extension UITableView {
    func register<T: ViewWithNib>(_ cell: T.Type) where T: Reusable {
        register(UINib(nibName: T.nibName, bundle: .main), forCellReuseIdentifier: T.reuseIdentifier)
    }
}

import UIKit
