//
//  ProfileViewModel.swift
//  Flow
//
//  Created by Hanna Chen on 2022/2/16.
//

import UIKit
import Combine

class ProfileViewModel {
    // MARK: - Properties

    private let userID: UserID

    @Published private(set) var profileImageURL: URL?
    @Published private(set) var username: String?
    @Published private(set) var fullName: String?

    @Published private(set) var postList: [Post] = []
    @Published private(set) var mentionedList: [Post] = []

    init(userID: UserID) {
        self.userID = userID
        fetchUser()
    }

    func fetchUser() {
        // TODO: Fetch User
        UserService.fetchUser(id: userID) {[unowned self] user, error in
            if let error = error {
                print("DEBUG: Error fetching current user -", error.localizedDescription)
                return
            }
            guard let user = user else {
                print("DEBUG: Fetched empty user document")
                return
            }
            profileImageURL = URL(string: user.profileImageURL)
            username = "@" + user.username
            fullName = user.fullName
        }
    }

    func fetchPosts() {
        // TODO: Fetch User's PostIDs by UserID
    }

    func fetchMentionedPosts() {
        // TODO: Fetch User's PostIDs by UserID
    }
}
