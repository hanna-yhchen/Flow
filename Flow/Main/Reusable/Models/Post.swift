//
//  Post.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/12.
//

import Foundation

typealias UserID = String
typealias PostID = String

struct Post: Hashable {
    let id: PostID
    let authorID: UserID
    let photoURL: URL?
    let caption: String
    let date: Date
    let whoLikes: [UserID]
    let comments: Comments
    let whoBookmarks: [UserID]

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
}
