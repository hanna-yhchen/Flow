//
//  SearchFlowController.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/8.
//

import UIKit

class SearchFlowController: UIViewController {
    // MARK: - Properties

    weak var barButtonDelegate: BarButtonDelegate?
    private let navigation: FNavigationController

    // MARK: - Lifecycle

    init(barButtonDelegate: BarButtonDelegate, navigation: FNavigationController = FNavigationController()) {
        self.barButtonDelegate = barButtonDelegate
        self.navigation = navigation

        super.init(nibName: nil, bundle: nil)
        add(child: navigation)
        showSearch()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func showSearch() {
        let searchVC = SearchViewController()
        searchVC.delegate = self
        barButtonDelegate?.configureBarButtons(in: searchVC)
        navigation.show(searchVC, sender: self)
    }
}

extension SearchFlowController: SearchViewControllerDelegate {
    func navigateToPost(_ post: Post) {
        let postVC = PostViewController(post: post)
        navigation.pushViewController(postVC, animated: true)
    }
}
