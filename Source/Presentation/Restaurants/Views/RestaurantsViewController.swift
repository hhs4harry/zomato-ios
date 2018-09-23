//
//  RestaurantsViewController.swift
//  zomato
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

final class RestaurantsViewController: UIViewController, PresenterSource {

    // MARK: - Properties

    // MARK: Private

    private var results: [RestaurantItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: IBOutlets

    @IBOutlet private var tableView: UITableView! {
        didSet {
            tableView.register(RestaurantView.self)
        }
    }

    // MARK: - Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.viewDidBecomeReady()
    }

    // MARK: - Conformance

    // MARK: PresenterSource

    var presenter: RestaurantsPresenting!
}

// MARK: - Conformance

// MARK: RestaurantsDisplay

extension RestaurantsViewController: RestaurantsDisplay {
    func show(restaurants: [RestaurantItem]) {
        self.results = restaurants
    }
}

// MARK: RestaurantsRouter

extension RestaurantsViewController: RestaurantsRouter {}

// MARK: - TableViewDataSource

extension RestaurantsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RestaurantView = tableView.dequeueReusableTableViewCell(RestaurantView.self, for: indexPath)
        cell.configure(withItem: results[indexPath.row])
        return cell
    }
}

// MARK: DependencyInjectionAware

extension RestaurantsViewController: DependencyInjectionAware {
    static func register(in container: Container) {
        container.storyboardInitCompleted(RestaurantsViewController.self) { resolver, controller in
            controller.presenter = resolver.resolve(
                RestaurantsPresenting.self,
                arguments: controller as RestaurantsDisplay, controller as RestaurantsRouter
            )!
        }
    }
}

import Swinject
import UIKit
