//
//  RegisterViewModel.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/6.
//

import UIKit
import Combine

class RegisterViewModel {
    // MARK: - Properties

    @Published var profileImage: UIImage?
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var fullName: String = ""
    @Published var username: String = ""

    @Published private var isPasswordConfirmed = false

    private var subscriptions = Set<AnyCancellable>()

    private(set) lazy var isInputValid = Publishers.CombineLatest4($email, $fullName, $username, $isPasswordConfirmed)
        .map { email, fullName, username, isPasswordConfirmed in
            email.count > 2 && fullName.count > 2 && username.count > 2 && isPasswordConfirmed
        }
        .eraseToAnyPublisher()

    // MARK: - LifeCycle

    init() {
        Publishers.CombineLatest($password, $confirmPassword)
            .map { $0.count >= 6 && $0 == $1 }
            .assign(to: &$isPasswordConfirmed)
    }

    // MARK: - Methods

    func register(completion: @escaping(Error?) -> Void) {
        // TODO: Validate Credentials
        guard let profileImage = profileImage else {
            return
        }
        let credentials = AuthCredentials(
            email: email,
            password: password,
            username: username,
            fullName: fullName,
            profileImage: profileImage
        )
        AuthService.register(with: credentials, completion: completion)
    }
}
