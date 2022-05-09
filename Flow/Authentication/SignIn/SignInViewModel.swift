//
//  SignInViewModel.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/4.
//

import Combine
import FirebaseAuth

class SignInViewModel {
    @Published var email: String = ""
    @Published var password: String = ""

    private(set) lazy var isInputValid = Publishers.CombineLatest($email, $password)
        .map { $0.count > 2 && $1.count > 2 }
        .eraseToAnyPublisher()

    func signIn(completion: @escaping AuthDataResultCallback) {
        // TODO: Validate credentials first
        AuthService.signIn(email: email, password: password, completion: completion)
    }
}
