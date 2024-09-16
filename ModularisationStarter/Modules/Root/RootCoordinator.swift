//
//  RootCoordinator.swift
//  ModularisationStarter
//
//  Created by Emre Havan on 13.02.24.
//

import UIKit

final class RootCoordinator {

    func makeInitialView() -> UIViewController {
        let homeView = HomeCoordinator().makeViewController()
        let tabBarController = RootTabBarController(viewControllers: [homeView])
        return tabBarController
    }
}
