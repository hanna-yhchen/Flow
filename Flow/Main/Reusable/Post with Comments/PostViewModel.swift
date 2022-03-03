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
    @Published private(set) var authorProfileImageURL: URL?
    @Published private(set) var userProfileImageURL: URL?
    private(set) var currentUserID: UserID?

    init(post: Post) {
        self.post = post
        fetchAuthor()
        fetchCurrentUser()
        fetchComments()
    }

    func reload(with post: Post) {
        self.post = post
        fetchPost()
        fetchComments()
    }

    private func fetchAuthor() {
        UserService.fetchUser(id: post.authorID) {[unowned self] user, error in
            if let error = error {
                print("DEBUG: Error fetching current user -", error.localizedDescription)
            }
            guard let user = user else {
                print("DEBUG: Fetched empty user document")
                return
            }
            self.authorProfileImageURL = URL(string: user.profileImageURL)
        }
    }

    private func fetchCurrentUser() {
        guard let currentUserID = UserService.currentUserID() else {
            print("DEBUG: Failed to fetch current user ID")
            return
        }
        self.currentUserID = currentUserID

        UserService.fetchUser(id: currentUserID) {[unowned self] user, error in
            if let error = error {
                print("DEBUG: Error fetching current user -", error.localizedDescription)
                return
            }
            guard let user = user else {
                print("DEBUG: Fetched empty user document")
                return
            }
            self.userProfileImageURL = URL(string: user.profileImageURL)
        }
    }

    private func fetchPost() {
        PostService.fetchPost(post.id) {[unowned self] post, error in
            if let error = error {
                print("DEBUG: Error fetching posts -", error.localizedDescription)
            }
            if let post = post {
                self.post = post
            }
        }
    }

    private func fetchComments() {
        PostService.fetchComments(of: post.id) {[unowned self] comments, error in
            if let error = error {
                print("DEBUG: Error fetching comments -", error.localizedDescription)
            }
            self.comments = comments
        }
    }
}
