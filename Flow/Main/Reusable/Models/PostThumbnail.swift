//
//  PostThumbnail.swift
//  Flow
//
//  Created by Hanna Chen on 2022/2/14.
//

import Foundation
import UIKit

struct PostThumbnail: Hashable {
    let id: PostID
    let thumbnail: UIImage?

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: PostThumbnail, rhs: PostThumbnail) -> Bool {
        return lhs.id == rhs.id
    }
}
