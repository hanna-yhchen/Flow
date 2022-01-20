//
//  Comment.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/12.
//

import Foundation

struct Comments {
    let postID: String
    let count: Int
}

struct Comment: Hashable {
    let authorID: UserID
    let content: String
    let date: Date

    func hash(into hasher: inout Hasher) {
        hasher.combine(authorID)
    }

    static func == (lhs: Comment, rhs: Comment) -> Bool {
        return lhs.authorID == rhs.authorID
    }
}
