//
//  Post.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/12.
//

import Foundation

typealias UserID = String
typealias PostID = String

struct Post: Hashable, Codable {
    let id: PostID
    let authorID: UserID
    let imageURL: String
    let caption: String
    let timeIntervalSince1970: Double
    let whoLikes: [UserID]
    let whoBookmarks: [UserID]
    let countOfComment: Int

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
}
