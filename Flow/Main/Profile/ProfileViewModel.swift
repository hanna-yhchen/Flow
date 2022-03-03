//
//  ProfileViewModel.swift
//  Flow
//
//  Created by Hanna Chen on 2022/2/16.
//

import Foundation
import Combine

class ProfileViewModel {
    // MARK: - Properties

    private let userID: UserID
    private var user: User?
    var isCurrentUser: Bool { userID == UserService.currentUserID() }

    @Published private(set) var profileImageURL: URL?
    @Published private(set) var username: String?
    @Published private(set) var fullName: String?

    @Published private(set) var posts: [Post] = []
    @Published private(set) var bookmarks: [Post] = []

    init(userID: UserID) {
        self.userID = userID
        fetchUser()
    }

    func reload() {
        posts = []
        bookmarks = []
        fetchPosts()
        fetchBookmarks()
    }

    func fetchUser() {
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

            self.user = user
            fetchBookmarks()
            fetchPosts()
        }
    }

    private func fetchPosts() {
        PostService.fetchPosts(of: userID) {[unowned self] posts, error in
            if let error = error {
                print("DEBUG: Error fetching posts -", error.localizedDescription)
                return
            }
            self.posts = posts
        }
    }

    private func fetchBookmarks() {
        guard let bookmarkIDs = user?.bookmarkedPosts else { return }

        for id in bookmarkIDs {
            PostService.fetchPost(id) { bookmark, error in
                if let error = error {
                    print("DEBUG: Error fetching bookmark -", error.localizedDescription)
                    return
                }
                guard let bookmark = bookmark else {
                    print("DEBUG: Fetched empty post document")
                    return
                }
                self.bookmarks.append(bookmark)
            }
        }
    }
}
