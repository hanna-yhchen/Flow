//
//  ProfileFlowController.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/8.
//

import UIKit
import FirebaseAuth

class ProfileFlowController: UIViewController {
    // MARK: - Properties

    weak var barButtonDelegate: BarButtonDelegate?
    private let navigation: FNavigationController

    // MARK: - Lifecycle

    init(barButtonDelegate: BarButtonDelegate, navigation: FNavigationController = FNavigationController()) {
        self.barButtonDelegate = barButtonDelegate
        self.navigation = navigation

        super.init(nibName: nil, bundle: nil)
        add(child: navigation)
        showProfile()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func showProfile() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("DEBUG: Absent current user")
            return
        }
        let profileVC = ProfileViewController(userID: currentUserId, isCurrentUser: true)
        profileVC.delegate = self
        barButtonDelegate?.configureBarButtons(in: profileVC)
        navigation.show(profileVC, sender: self)
    }
}

extension ProfileFlowController: ProfileViewControllerDelegate {
    func navigateToPost(_ post: Post) {
        let postVC = PostViewController(post: post)
        navigation.pushViewController(postVC, animated: true)
    }
}
