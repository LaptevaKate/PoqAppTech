//
//  AppCoordinator.swift
//  PoqAppTech
//
//  Created by Екатерина Лаптева on 10.07.24.
//

import UIKit

import UIKit

class AppCoordinator {
    private let window: UIWindow
    private let navigationController: UINavigationController

    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }

    func start() {
        let repoViewModel = RepoViewModel(networkManager: NetworkManager())
        let viewController = RepoViewController(viewModel: repoViewModel)
        viewController.coordinator = self
        navigationController.setViewControllers([viewController], animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func showDetailScreen(with repo: RepositoryModel) {
        let detailViewController = RepoDetailsViewController(repo: repo)
        detailViewController.coordinator = self
        navigationController.pushViewController(detailViewController, animated: true)
    }

    func navigateBack() {
        navigationController.popViewController(animated: true)
    }
}
