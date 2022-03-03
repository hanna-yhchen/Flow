//
//  HomeFlowController.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/8.
//

import UIKit

class HomeFlowController: UIViewController {
    // MARK: - Properties

    weak var barButtonDelegate: BarButtonDelegate?
    private let navigation: FNavigationController
    private var homeVC: HomeViewController?

    // MARK: - Lifecycle

    init(barButtonDelegate: BarButtonDelegate, navigation: FNavigationController = FNavigationController()) {
        self.barButtonDelegate = barButtonDelegate
        self.navigation = navigation

        super.init(nibName: nil, bundle: nil)
        add(child: navigation)
        showHome()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func reload() {
        homeVC?.reload()
    }

    // MARK: - Private

    private func showHome() {
        let homeVC = HomeViewController()
        homeVC.delegate = self
        barButtonDelegate?.configureBarButtons(in: homeVC)
        navigation.show(homeVC, sender: self)

        self.homeVC = homeVC
    }
}

// MARK: - HomeViewControllerDelegate

extension HomeFlowController: HomeViewControllerDelegate, PostViewControllerDelegate, ProfileViewControllerDelegate {
    func navigateToPost(_ post: Post) {
        let postVC = PostViewController(post: post)
        postVC.delegate = self
        navigation.pushViewController(postVC, animated: true)
    }
    func navigateToProfile(_ authorID: UserID) {
        let profileVC = ProfileViewController(userID: authorID)
        profileVC.delegate = self
        navigation.pushViewController(profileVC, animated: true)
    }
    func postNeedUpdate(_ post: Post) {
        homeVC?.update(post)
    }
}
