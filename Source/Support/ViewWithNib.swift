//
//  ViewWithNib.swift
//  zomato
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

protocol ViewWithNib {
    static var nibName: String { get }
}

extension ViewWithNib {
    static var nibName: String { return String(describing: self) }
}

extension ViewWithNib where Self: UIView {
    static func loadFromNib<T>() -> T {
        return UINib(nibName: nibName, bundle: .main).instantiate(withOwner: nil, options: nil).first as! T
    }
}

import UIKit
