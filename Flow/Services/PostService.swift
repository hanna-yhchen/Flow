//
//  PostService.swift
//  Flow
//
//  Created by Hanna Chen on 2022/2/23.
//

import FirebaseFirestoreSwift
import FirebaseFirestore
import UIKit

enum PostService {
    private static let postRef = Firestore.firestore().collection("posts")
    // TODO: CRUD post
    static func create(_ newPost: NewPost, completion: @escaping(Error?) -> Void) {
        ImageService.upload(image: newPost.image, to: .postImages) { imageURL, error in
            guard error == nil, let imageURL = imageURL?.absoluteString, let userID = UserService.currentUserID() else {
                completion(error)
                return
            }

            let newDocument = postRef.document()
            let postID = newDocument.documentID
            let post = Post(
                id: postID,
                authorID: userID,
                imageURL: imageURL,
                caption: newPost.caption ?? "",
                timeIntervalSince1970: Date().timeIntervalSince1970,
                whoLikes: [],
                whoBookmarks: [],
                countOfComment: 0
            )

            do {
                try newDocument.setData(from: post)
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

    static func fetchPost(_ postID: PostID, completion: @escaping(Post?, Error?) -> Void) {
        Firestore.firestore().collection("posts").document(postID).getDocument { document, error in
            do {
                let post = try document?.data(as: Post.self)
                completion(post, error)
            } catch {
                completion(nil, error)
            }
        }
    }

    static func fetchPosts(of userID: UserID, completion: @escaping([Post], Error?) -> Void) {
        postRef.whereField("authorID", isEqualTo: userID)
            .order(by: "timeIntervalSince1970", descending: true)
            .limit(to: 30)
            .getDocuments { snapshot, error in
                completion(posts(in: snapshot), error)
            }
    }

    static func fetchAllPosts(completion: @escaping([Post], Error?) -> Void) {
        postRef.order(by: "timeIntervalSince1970", descending: true)
            .limit(to: 30)
            .getDocuments { snapshot, error in
                completion(posts(in: snapshot), error)
            }
    }

    private static func posts(in snapshot: QuerySnapshot?) -> [Post] {
        var posts: [Post] = []

        if let snapshot = snapshot {
            for document in snapshot.documents {
                do {
                    guard let post = try document.data(as: Post.self) else { continue }
                    posts.append(post)
                } catch {
                    print("DEBUG: Error decoding post data -", error.localizedDescription)
                }
            }
        }

        return posts
    }
}
