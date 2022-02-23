//
//  PostService.swift
//  Flow
//
//  Created by Hanna Chen on 2022/2/23.
//

import FirebaseFirestoreSwift
import FirebaseFirestore

struct NewPost {
    let image: UIImage?
    let caption: String?
}

enum PostService {
    // TODO: CRUD post
    static func create(_ newPost: NewPost, completion: @escaping(Error?) -> Void) {
        ImageService.upload(image: newPost.image, to: .postImages) { imageURL, error in
            guard error == nil, let imageURL = imageURL?.absoluteString, let userID = UserService.currentUserID() else {
                completion(error)
                return
            }

            let postRef = Firestore.firestore().collection("posts").document()

            let postID = postRef.documentID

            let post = Post(
                id: postID,
                authorID: userID,
                imageURL: imageURL,
                caption: newPost.caption ?? "",
                timeIntervalSince1970: Date().timeIntervalSince1970,
                whoLikes: [],
                whoBookmarks: []
            )

            do {
                try postRef.setData(from: post)
                /// Update user's post list
                Firestore.firestore().collection("users").document(userID).updateData([
                    "posts": FieldValue.arrayUnion([postID])
                ])
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
}
