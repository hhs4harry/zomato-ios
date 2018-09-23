//
//  RestaurantView.swift
//  zomato
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

struct RestaurantItem {
    let image: UIImage
    let title: String
    let subTitle: String
}

final class RestaurantView: UITableViewCell, ViewWithNib, Reusable {

    // MARK: - Properties

    // MARK: IBOutlets

    @IBOutlet private var backgroundImageView: UIImageView!

    @IBOutlet private var titleLabel: UILabel!

    @IBOutlet private var subTitleLabel: UILabel!

    // MARK: - Helpers

    func configure(withItem item: RestaurantItem) {
        backgroundImageView.image = item.image
        titleLabel.text = item.title
        subTitleLabel.text = item.subTitle
    }
}

import UIKit
