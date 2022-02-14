//
//  ProfileFlowController.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/8.
//

import UIKit

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
        //TODO: get current User
        let testUser = User(id: "007", username: "username", profileImageURL: "", fullName: "Name", followers: [], posts: [], mentionedPosts: [])
        let profileVC = ProfileViewController(user: testUser)
        profileVC.delegate = self
        barButtonDelegate?.configureBarButtons(in: profileVC)
        navigation.show(profileVC, sender: self)
    }
}

extension ProfileFlowController: ProfileViewControllerDelegate {
    func navigateToPost(id: String) {
        let testPost = Post(id: id, authorID: "", thumbnailURL: "", photoURLs: [], caption: "Test caption", date: Date(), whoLikes: [], comments: Comments(postID: "", count: 0), whoBookmarks: [])
        let postVC = PostViewController(postID: id, post: testPost)
        navigation.pushViewController(postVC, animated: true)
    }
}
