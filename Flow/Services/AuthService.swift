//
//  AuthService.swift
//  Flow
//
//  Created by Hanna Chen on 2022/2/22.
//

import FirebaseAuth
import FirebaseFirestore

typealias AuthDataResultCallback = (AuthDataResult?, Error?) -> Void

struct AuthCredentials {
    let email: String
    let password: String
    let username: String
    let fullName: String
    let profileImage: UIImage
}

enum AuthService {
    static func signIn(email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }

    static func register(with credentials: AuthCredentials, completion: @escaping(Error?) -> Void) {
        ImageService.upload(image: credentials.profileImage, to: .profileImages) { imageURL in
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
                guard error == nil, let id = result?.user.uid else {
                    completion(error)
                    return
                }

                let newUser = User(
                    id: id,
                    username: credentials.username,
                    profileImageURL: imageURL,
                    fullName: credentials.fullName,
                    follows: [],
                    followers: [],
                    posts: [],
                    bookmarkedPosts: []
                )

                do {
                    try Firestore.firestore().collection("users").document(id).setData(from: newUser)
                    completion(nil)
                } catch {
                    completion(error)
                }
            }
        }
    }
}
