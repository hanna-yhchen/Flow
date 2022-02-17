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

    @Published private(set) var profileImage: UIImage?
    @Published private(set) var username: String?
    @Published private(set) var fullName: String?

    @Published private(set) var postList: [PostThumbnail] = []
    @Published private(set) var mentionedList: [PostThumbnail] = []

    init(userID: UserID) {
        self.userID = userID
        fetchUser()
    }

    func fetchUser() {
        // TODO: Fetch User
        let user = User(id: "007", username: "username", profileImageURL: "", fullName: "Name", followers: [], posts: [], mentionedPosts: [])
        // TODO: Fetch Profile Image
        profileImage = UIImage(named: "keanu")
        username = "@" + user.username
        fullName = user.fullName
    }

    func fetchPosts() {
        // TODO: Fetch User's PostIDs by UserID
    }

    func fetchMentionedPosts() {
        // TODO: Fetch User's PostIDs by UserID
    }
}
