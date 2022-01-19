//
//  Comment.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/12.
//

import Foundation

struct Comments {
    let postID: String
    let list: [Comment]
}

struct Comment {
    let authorID: UserID
    let authorName: String
    let content: String
    let date: Date
}
