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
    private static let commentRef = Firestore.firestore().collection("comments")

    static func create(_ newPost: NewPost, completion: @escaping(Error?) -> Void) {
        ImageService.upload(image: newPost.image, to: .postImages) { imageURL in
            guard let userID = UserService.currentUserID() else {
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

    static func fetchPost(_ postID: PostID, completion: @escaping (Post) -> Void) {
        postRef.document(postID).getDocument(as: Post.self) { result in
            switch result {
            case .success(let post):
                UserService.fetchUser(id: post.authorID) { author in
                    completion(post.withAuthorInfo(author))
                }
            case .failure(let error):
                print("DEBUG: Error decoding post -", error.localizedDescription)
                return
            }
        }
    }

    static func fetchPosts(of userID: UserID, completion: @escaping ([Post]) -> Void) {
        postRef.whereField("authorID", isEqualTo: userID)
            .order(by: "timeIntervalSince1970", descending: true)
            .limit(to: 30)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("DEBUG: Error getting post documents -", error.localizedDescription)
                    return
                }

                fetchAuthors(for: posts(in: snapshot), completion: completion)
            }
    }

    static func fetchAllPosts(completion: @escaping ([Post]) -> Void) {
        postRef.order(by: "timeIntervalSince1970", descending: true)
            .limit(to: 30)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("DEBUG: Error getting post documents -", error.localizedDescription)
                    return
                }

                completion(posts(in: snapshot))
                // fetchAuthors(for: posts(in: snapshot), completion: completion)
            }
    }

    static func update(_ post: Post) {
        let document = postRef.document(post.id)
        do {
            try document.setData(from: post)
        } catch {
            print("DEBUG: Error updating post -", error.localizedDescription)
        }
    }

    static func create(_ comment: Comment, of post: Post, completion: @escaping(Error?) -> Void) {
        let newDocument = commentRef.document(post.id).collection("comments").document()
        do {
            try newDocument.setData(from: comment)
            completion(nil)
        } catch {
            completion(error)
        }
    }

    static func fetchComments(of postID: PostID, completion: @escaping ([Comment]) -> Void) {
        let ref = commentRef.document(postID).collection("comments")
        ref.order(by: "timeIntervalSince1970", descending: false).getDocuments { snapshot, error in
            if let error = error {
                print("DEBUG: Error getting comment documents -", error.localizedDescription)
                return
            }

            var comments: [Comment] = []

            if let snapshot = snapshot {
                for document in snapshot.documents {
                    do {
                        let comment = try document.data(as: Comment.self)
                        comments.append(comment)
                    } catch {
                        print("DEBUG: Error decoding comment data -", error.localizedDescription)
                    }
                }
            }

            completion(comments)
        }
    }

    /// Return an array of post from the given query snapshot.
    private static func posts(in snapshot: QuerySnapshot?) -> [Post] {
        var posts: [Post] = []

        if let snapshot = snapshot {
            for document in snapshot.documents {
                do {
                    let post = try document.data(as: Post.self)
                    posts.append(post)
                } catch {
                    print("DEBUG: Error decoding post data -", error.localizedDescription)
                }
            }
        }

        return posts
    }

    private static func fetchAuthors(for posts: [Post], completion: @escaping ([Post]) -> Void) {
        let semaphore = DispatchSemaphore(value: 0)

        DispatchQueue.global().async {
            var updatedPosts: [Post] = []

            for post in posts {
                UserService.fetchUser(id: post.authorID) { author in
                    updatedPosts.append(post.withAuthorInfo(author))

                    semaphore.signal()
                }
                semaphore.wait()
            }

            completion(updatedPosts)
        }
    }
}
