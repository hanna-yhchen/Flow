//
//  SearchViewModel.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/12.
//

import Foundation
import Combine

class SearchViewModel {
    @Published private(set) var posts: [Post] = []

    init() {
        fetchPosts()
    }

    func reload() {
        fetchPosts()
    }

    private func fetchPosts() {
        PostService.fetchAllPosts {[unowned self] posts, error in
            if let error = error {
                print("DEBUG: Error fetching posts -", error.localizedDescription)
            }
            self.posts = posts
        }
    }
}
