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
        PostService.fetchAllPosts {[unowned self] posts in
            self.posts = posts
        }
    }
}
