//
//  User.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/12.
//

import Foundation

struct User: Codable {
    let id: UserID
    var username: String
    var profileImageURL: String
    var fullName: String
    var follows: [UserID]
    var followers: [UserID]
    var posts: [PostID]
    var bookmarkedPosts: [PostID]
}
