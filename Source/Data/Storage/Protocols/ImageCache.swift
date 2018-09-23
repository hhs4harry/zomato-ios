//
//  ImageCache.swift
//  zomato
//
//  Created by Harry on 24/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

protocol ImageCache {
    func store(image: UIImage, named: String)
    func retrive(imageNamed name: String) -> UIImage?
}

import Foundation
import UIKit.UIImage
