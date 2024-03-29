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
    private var profileVC: ProfileViewController?

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

    // MARK: - Methods

    func reload() {
        profileVC?.reload()
    }

    // MARK: - Private

    private func showProfile() {
        guard let currentUserId = UserService.currentUserID() else {
            print("DEBUG: Absent current user")
            return
        }
        let profileVC = ProfileViewController(userID: currentUserId)
        profileVC.delegate = self
        barButtonDelegate?.configureBarButtons(in: profileVC)
        navigation.show(profileVC, sender: self)

        self.profileVC = profileVC
    }
}

extension ProfileFlowController: ProfileViewControllerDelegate, PostViewControllerDelegate {
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
