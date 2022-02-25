//
//  Comment.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/12.
//

import Foundation

struct Comment: Hashable {
    let authorID: UserID
    let content: String
    let timeIntervalSince1970: Double

    func hash(into hasher: inout Hasher) {
        hasher.combine(authorID)
    }

    static func == (lhs: Comment, rhs: Comment) -> Bool {
        return lhs.authorID == rhs.authorID
    }
}
