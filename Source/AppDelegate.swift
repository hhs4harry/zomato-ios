//
//  AppDelegate.swift
//  zomato-ios
//
//  Created by Harry on 4/04/18.
//  Copyright © 2018 |x|. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Conformance

    // MARK: UIApplicationDelegate

    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]? = nil
    ) -> Bool {
        Dependencies.initialise(in: SwinjectStoryboard.defaultContainer)

        return true
    }

    // MARK: - Properties

    var window: UIWindow?
}

import Swinject
import SwinjectStoryboard
