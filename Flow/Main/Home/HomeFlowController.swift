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

    // MARK: - Private

    private func showHome() {
        let homeVC = HomeViewController()
        homeVC.delegate = self
        barButtonDelegate?.configureBarButtons(in: homeVC)
        navigation.show(homeVC, sender: self)
    }
}

// MARK: - FeedViewControllerDelegate

extension HomeFlowController: FeedViewControllerDelegate {
    func navigateToPost(id: String) {
    }

    func navigateToCommentOfPost(id: String) {
    }
}
