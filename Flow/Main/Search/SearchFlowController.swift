//
//  SearchFlowController.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/8.
//

import UIKit

class SearchFlowController: UIViewController {
    // MARK: - Properties

    private let navigation: CustomNavigationController

    // MARK: - Lifecycle

    init(navigation: CustomNavigationController = CustomNavigationController()) {
        self.navigation = navigation
        navigation.navigationBar.prefersLargeTitles = false
        //navigation.isNavigationBarHidden = true

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
        add(child: searchVC)
        navigation.show(searchVC, sender: self)
    }
}

extension SearchFlowController: SearchViewControllerDelegate {
}
