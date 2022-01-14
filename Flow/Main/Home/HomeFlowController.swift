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
    private let navigation: CustomNavigationController

    // MARK: - Lifecycle

    init(barButtonDelegate: BarButtonDelegate, navigation: CustomNavigationController = CustomNavigationController()) {
        self.barButtonDelegate = barButtonDelegate
        self.navigation = navigation

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
        barButtonDelegate?.configureBarButtons(in: feedVC)
        navigation.show(feedVC, sender: self)
    }
}

// MARK: - FeedViewControllerDelegate

extension HomeFlowController: FeedViewControllerDelegate {
}
