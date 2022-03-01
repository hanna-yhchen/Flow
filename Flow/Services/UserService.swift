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
            do {
                let user = try document?.data(as: User.self)
                completion(user, error)
            } catch {
                completion(nil, error)
            }
        }
    }

    static func currentUserID() -> UserID? {
        return Auth.auth().currentUser?.uid
    }

    static func fetchAllUsers(completion: @escaping([User], Error?) -> Void) {
        Firestore.firestore().collection("users").getDocuments { snapshot, error in
            var users: [User] = []

            if let snapshot = snapshot {
                for document in snapshot.documents {
                    do {
                        guard let user = try document.data(as: User.self) else { continue }
                        users.append(user)
                    } catch {
                        print("DEBUG: Error decoding user data -", error.localizedDescription)
                    }
                }
            }

            completion(users, error)
        }
    }
}
