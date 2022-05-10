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
    var caption: String
    let timeIntervalSince1970: Double
    var whoLikes: [UserID]
    var whoBookmarks: [UserID]
    var countOfComment: Int

    var authorName: String?
    var authorUserName: String?
    var authorImageURL: String?

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }

    func withAuthorInfo(_ author: User) -> Post {
        var post = self

        post.authorImageURL = author.profileImageURL
        post.authorName = author.fullName
        post.authorUserName = author.username

        return post
    }
}
