//
//  DI.swift
//  zomato
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

protocol DependencyInjectionAware {
    static func register(in container: Container)
}

final class Dependencies {
    private(set) static var container: Container!

    static let managedclasses: [DependencyInjectionAware.Type] = [

        // MARK: Presentation

        SplashPresenter.self,
        SplashViewController.self,
        SearchPresenter.self,
        SearchViewController.self,

        // MARK: Domain

        SearchUseCaseImplementation.self,

        // MARK: Data

        HTTPClient.self,
        SearchService.self,
        Endpoint.self,
    ]

    static func initialise(in container: Container) {
        self.container = container

        managedclasses.forEach { $0.register(in: container) }
    }
}

import Swinject
