//
//  PostService.swift
//  Flow
//
//  Created by Hanna Chen on 2022/2/23.
//

import FirebaseFirestoreSwift
import FirebaseFirestore

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

    static func fetchPost(_ postID: PostID, completion: @escaping(Post?, Error?) -> Void) {
        Firestore.firestore().collection("posts").document(postID).getDocument { document, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            do {
                let post = try document?.data(as: Post.self)
                completion(post, nil)
            } catch {
                completion(nil, error)
            }
        }
    }

    static func fetchPosts(of userID: UserID, completion: @escaping([Post], Error?) -> Void) {
        let postsRef = Firestore.firestore().collection("posts")
        postsRef.whereField("authorID", isEqualTo: userID)
            .order(by: "timeIntervalSince1970", descending: true)
            .limit(to: 30)
            .getDocuments { snapshot, error in
                guard error == nil, let snapshot = snapshot else {
                    completion([], error)
                    return
                }

                var posts: [Post] = []
                for document in snapshot.documents {
                    do {
                        guard let post = try document.data(as: Post.self) else { return }
                        posts.append(post)
                    } catch {
                        print("DEBUG: Error fetching post -", error.localizedDescription)
                    }
                }

                completion(posts, nil)
            }
    }
}
