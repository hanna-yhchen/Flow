//
//  HomeViewModel.swift
//  Flow
//
//  Created by Hanna Chen on 2022/3/1.
//

import Foundation
import Combine

class HomeViewModel {
    // MARK: - Properties

    @Published private(set) var posts: [Post] = []
    @Published private(set) var storybooks: [Storybook] = []
    private(set) var currentUserID: UserID?

    init() {
        currentUserID = UserService.currentUserID()
        fetchPosts()
        fetchStorybooks()
    }

    // MARK: - Methods

    func reload() {
        fetchPosts()
        fetchStorybooks()
    }

    func update(_ post: Post) {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else { return }
        posts[index] = post
    }

    // MARK: - Private

    private func fetchPosts() {
        PostService.fetchAllPosts {[unowned self] posts in
            self.posts = posts
        }
    }

    private func fetchStorybooks() {
        var storybooks: [Storybook] = []

        UserService.fetchAllUsers { users in
            for user in users {
                let storybook = Storybook(authorID: user.id, whoHasReadAll: [])
                if storybook.authorID == self.currentUserID {
                    storybooks.insert(storybook, at: 0)
                } else {
                    storybooks.append(storybook)
                }
            }

            self.storybooks = storybooks
        }
        // TODO: Fetch Storybooks and Sorted
    }
}
