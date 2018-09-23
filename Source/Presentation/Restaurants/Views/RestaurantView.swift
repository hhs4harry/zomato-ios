//
//  RestaurantView.swift
//  zomato
//
//  Created by Harry on 23/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

struct RestaurantItem {
    let image: SignalProducer<UIImage?, NoError>
    let title: String
    let subTitle: String
}

final class RestaurantView: UITableViewCell, ViewWithNib, Reusable {

    // MARK: - Properties

    // MARK: Private

    private var disposable: Disposable?

    // MARK: IBOutlets

    @IBOutlet private var backgroundImageView: UIImageView!

    @IBOutlet private var titleLabel: UILabel! {
        didSet {
            titleLabel.font = Theme.Restaurants.Font.title
            titleLabel.textColor = Theme.Restaurants.Color.title
        }
    }

    @IBOutlet private var subTitleLabel: UILabel! {
        didSet {
            subTitleLabel.font = Theme.Restaurants.Font.subTitle
            subTitleLabel.textColor = Theme.Restaurants.Color.subTitle
        }
    }

    private var gradient: CAGradientLayer!

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()

        gradient = CAGradientLayer()
        gradient.frame = .init(x: 0, y: 0, width: frame.width, height: frame.height)
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]

        gradient.startPoint = .init(x: 0, y: 0)
        gradient.endPoint = .init(x: 0, y: 1)

        backgroundImageView.layer.insertSublayer(gradient, at: 0)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        disposable?.dispose()
        backgroundImageView.image = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gradient.frame = .init(x: 0, y: 0, width: frame.width, height: frame.height)
    }

    // MARK: - Helpers

    func configure(withItem item: RestaurantItem) {
        disposable = backgroundImageView.reactive.image <~ item.image
        titleLabel.text = item.title
        subTitleLabel.text = item.subTitle
    }
}

import ReactiveSwift
import enum Result.NoError
import UIKit
