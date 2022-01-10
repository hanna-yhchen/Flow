//
//  HomeFlowController.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/8.
//

import UIKit

class HomeFlowController: UIViewController {
    // MARK: - Properties

    private let navigation: CustomNavigationController

    // MARK: - Lifecycle

    init(navigation: CustomNavigationController = CustomNavigationController()) {
        self.navigation = navigation
        navigation.navigationBar.prefersLargeTitles = true

        super.init(nibName: nil, bundle: nil)
        add(child: navigation)
        showFeed()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func showFeed() {
        let feedVC = FeedViewController()
        feedVC.delegate = self
        navigation.show(feedVC, sender: self)
    }
}

// MARK: - FeedViewControllerDelegate

extension HomeFlowController: FeedViewControllerDelegate {
}
