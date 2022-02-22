//
//  AuthService.swift
//  Flow
//
//  Created by Hanna Chen on 2022/2/22.
//

import FirebaseAuth
import FirebaseFirestore

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
        ImageService.upload(image: credentials.profileImage) { profileImageURL, error in
            guard error == nil else {
                completion(error)
                return
            }
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
                guard error == nil, let id = result?.user.uid, let url = profileImageURL?.absoluteString else {
                    completion(error)
                    return
                }

                Firestore.firestore().collection("users").document(id).setData(
                    [
                        "id": id,
                        "username": credentials.username,
                        "fullName": credentials.fullName,
                        "profileImageURL": url,
                        "follows": [],
                        "followers": [],
                        "posts": [],
                        "mentionedPosts": [],
                    ], completion: completion
                )
            }
        }
    }
}
