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
    private var searchVC: SearchViewController?

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

    // MARK: - Methods

    func reload() {
        searchVC?.reload()
    }

    // MARK: - Private

    private func showSearch() {
        let searchVC = SearchViewController()
        searchVC.delegate = self
        barButtonDelegate?.configureBarButtons(in: searchVC)
        navigation.show(searchVC, sender: self)
        self.searchVC = searchVC
    }
}

extension SearchFlowController: SearchViewControllerDelegate, PostViewControllerDelegate, ProfileViewControllerDelegate {
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
}
