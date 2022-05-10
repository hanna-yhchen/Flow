//
//  PostViewModel\.swift
//  Flow
//
//  Created by Hanna Chen on 2022/2/24.
//

import Foundation
import Combine

class PostViewModel {
    @Published private(set) var post: Post
    @Published private(set) var comments: [Comment] = []
    @Published private(set) var userProfileImageURL: URL?
    private(set) var currentUserID: UserID?

    init(post: Post) {
        self.post = post
        fetchCurrentUser()
        fetchComments()
    }

    func reload() {
        fetchPost()
        fetchComments()
    }

    private func fetchCurrentUser() {
        guard let currentUserID = UserService.currentUserID() else {
            print("DEBUG: Failed to fetch current user ID")
            return
        }
        self.currentUserID = currentUserID

        UserService.fetchUser(id: currentUserID) {[unowned self] user in
            self.userProfileImageURL = URL(string: user.profileImageURL)
        }
    }

    private func fetchPost() {
        PostService.fetchPost(post.id) {[unowned self] post in
            self.post = post
        }
    }

    private func fetchComments() {
        PostService.fetchComments(of: post.id) {[unowned self] comments in
            self.comments = comments
        }
    }
}
