//
//  Comment.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/12.
//

import Foundation

struct Comment: Hashable, Codable {
    let authorID: UserID
    let content: String
    let timeIntervalSince1970: Double

    func hash(into hasher: inout Hasher) {
        hasher.combine(timeIntervalSince1970)
    }

    static func == (lhs: Comment, rhs: Comment) -> Bool {
        return lhs.timeIntervalSince1970 == rhs.timeIntervalSince1970
    }
}
