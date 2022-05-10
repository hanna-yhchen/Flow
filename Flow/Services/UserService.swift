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
    private static let userRef = Firestore.firestore().collection("users")

    static func fetchUser(id: UserID, completion: @escaping (User) -> Void) {
        userRef.document(id).getDocument(as: User.self) { result in
            switch result {
            case .success(let user):
                completion(user)
            case .failure(let error):
                print("DEBUG: Error decoding user -", error.localizedDescription)
                return
            }
        }
    }

    static func currentUserID() -> UserID? {
        return Auth.auth().currentUser?.uid
    }

    static func fetchCurrentUser(completion: @escaping (User) -> Void) {
        guard let id = currentUserID() else {
            print("DEBUG: Missing current user id")
            return
        }
        fetchUser(id: id, completion: completion)
    }

    static func update(_ user: User) {
        let document = userRef.document(user.id)
        do {
            try document.setData(from: user)
        } catch {
            print("DEBUG: Error updating user -", error.localizedDescription)
        }
    }

    static func fetchAllUsers(completion: @escaping ([User]) -> Void) {
        userRef.getDocuments { snapshot, error in
            if let error = error {
                print("DEBUG: Error getting user documents -", error.localizedDescription)
                return
            }

            var users: [User] = []

            if let snapshot = snapshot {
                for document in snapshot.documents {
                    do {
                        let user = try document.data(as: User.self)
                        users.append(user)
                    } catch {
                        print("DEBUG: Error decoding user data -", error.localizedDescription)
                    }
                }
            }

            completion(users)
        }
    }
}
