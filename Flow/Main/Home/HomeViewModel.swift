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

    init() {
        fetchPosts()
        fetchStorybooks()
    }

    // MARK: - Methods

    func reload() {
        fetchPosts()
        fetchStorybooks()
    }

    // MARK: - Private

    private func fetchPosts() {
        PostService.fetchAllPosts {[unowned self] posts, error in
            if let error = error {
                print("DEBUG: Error fetching posts -", error.localizedDescription)
                return
            }
            self.posts = posts
        }
    }

    private func fetchStorybooks() {
        var storybooks: [Storybook] = []

        UserService.fetchAllUsers { users, error in
            if let error = error {
                print("DEBUG: Error fetching users -", error.localizedDescription)
            }
            for user in users {
                let storybook = Storybook(authorID: user.id, whoHasReadAll: [])
                storybooks.append(storybook)
            }

            self.storybooks = storybooks
        }
        // TODO: Fetch Storybooks and Sorted
    }
}