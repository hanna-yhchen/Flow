//
//  User.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/12.
//

import Foundation

struct User: Codable {
    let id: UserID
    let username: String
    let profileImageURL: String
    let fullName: String
    let follows: [UserID]
    let followers: [UserID]
    let posts: [PostID]
    let mentionedPosts: [PostID]
}
