//
//  UITableView+Dequeue.swift
//  zomato
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

extension UITableView {
    func dequeueReusableTableViewCell<T: Reusable>(_ reusable: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: reusable.reuseIdentifier, for: indexPath) as! T
    }
}

import UIKit
