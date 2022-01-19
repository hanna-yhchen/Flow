//
//  User.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/12.
//

import Foundation

struct User {
    let id: String
    let username: String
    let profileImageURL: FirebaseURL
    let fullName: String
    let followers: [UserID]
}
