//
//  ResultView.swift
//  zomato
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

struct Result {
    let title: String
    let action: ButtonAction
}

final class ResultView: UITableViewCell, ViewWithNib, Reusable {

    // MARK: - Properties

    // MARK: Private

    private var action: ButtonAction?

    // MARK: IBOutlets

    @IBOutlet private var titleLabel: UILabel!

    // MARK: - IBActions

    @IBAction private func primaryActionTriggered(_ sender: Any) {
        action?()
    }

    func configure(withItem item: Result) {
        titleLabel.text = item.title
        action = item.action
    }
}

import UIKit
