//
//  UserService.swift
//  Flow
//
//  Created by Hanna Chen on 2022/2/22.
//

import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

enum UserService {
    static func fetchUser(id: UserID, completion: @escaping(User?, Error?) -> Void) {
        Firestore.firestore().collection("users").document(id).getDocument { document, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            do {
                let user = try document?.data(as: User.self)
                completion(user, nil)
            } catch {
                completion(nil, error)
            }
        }
    }

    static func currentUserID() -> UserID? {
        return Auth.auth().currentUser?.uid
    }
}
