//
//  RegisterViewModel.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/6.
//

import UIKit
import Combine

class RegisterViewModel {
    @Published var profilePhoto: UIImage?
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

    init() {
        Publishers.CombineLatest($password, $confirmPassword)
            .map { $0 == $1 }
            .eraseToAnyPublisher()
            .assign(to: \.isPasswordConfirmed, on: self)
            .store(in: &subscriptions)
    }

    // TODO: Validate Credentials
}
