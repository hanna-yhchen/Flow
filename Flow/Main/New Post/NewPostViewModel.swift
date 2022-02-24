//
//  NewPostViewModel.swift
//  Flow
//
//  Created by Hanna Chen on 2022/2/23.
//

import UIKit
import Combine

struct NewPost {
    let image: UIImage?
    let caption: String?
}

class NewPostViewModel {
    // MARK: - Properties

    @Published var postImage: UIImage?
    var caption: String?

    private(set) lazy var isInputValid = $postImage
        .map { $0 != nil }
        .eraseToAnyPublisher()

    // MARK: - LifeCycle

    func share(completion: @escaping(Error?) -> Void) {
        let newPost = NewPost(image: postImage, caption: caption)
        PostService.create(newPost, completion: completion)
    }
}
