//
//  PresenterSource.swift
//  zomato
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

protocol PresenterSource {
    associatedtype Presenter

    var presenter: Presenter! { get set }
}
