//
//  SearchViewController.swift
//  zomato
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

final class SearchViewController: UIViewController, PresenterSource {

    // MARK: - Properties

    // MARK: Private

    private var results: [Result] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    private let disposable: CompositeDisposable = .init()

    // MARK: IBOutlets

    @IBOutlet private var tableView: UITableView! {
        didSet {
            tableView.estimatedRowHeight = UITableViewAutomaticDimension
            tableView.register(ResultView.self)
        }
    }

    @IBOutlet private var tableViewBottomConstraint: NSLayoutConstraint!

    @IBOutlet private var textField: UITextField!

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidBecomeReady()

        disposable += presenter.searchValue <~ textField.reactive.continuousTextValues.producer
    }

    // MARK: - Conformance

    // MARK: PresenterSource

    var presenter: SearchPresenting!
}

// MARK: SearchDisplay

extension SearchViewController: SearchDisplay {
    func set(placeholder: String) {
        textField.placeholder = placeholder
    }

    func show(results: [Result]) {
        self.results = results
    }
}

// MARK: SearchRouter

extension SearchViewController: SearchRouter {}

// MARK: - TableViewDataSource

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ResultView = tableView.dequeueReusableTableViewCell(ResultView.self, for: indexPath)
        cell.configure(withItem: results[indexPath.row])
        return cell
    }
}

// MARK: DependencyInjectionAware

extension SearchViewController: DependencyInjectionAware {
    static func register(in container: Container) {
        container.storyboardInitCompleted(SearchViewController.self) { resolver, controller in
            controller.presenter = resolver.resolve(
                SearchPresenting.self,
                arguments: controller as SearchDisplay, controller as SearchRouter
            )!
        }
    }
}

import ReactiveCocoa
import ReactiveSwift
import Swinject
import SwinjectStoryboard
import UIKit
