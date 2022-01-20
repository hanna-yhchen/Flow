//
//  Storybook.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/14.
//

import UIKit

struct Storybook: Hashable {
    let authorID: UserID
    let whoHasReadAll: [UserID]

    func hash(into hasher: inout Hasher) {
        hasher.combine(authorID)
    }

    static func == (lhs: Storybook, rhs: Storybook) -> Bool {
        return lhs.authorID == rhs.authorID
    }
}
