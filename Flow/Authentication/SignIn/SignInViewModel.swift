//
//  SignInViewModel.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/4.
//

import Foundation
import Combine

class SignInViewModel {
    @Published var email: String = ""
    @Published var password: String = ""

    private(set) lazy var isInputValid = Publishers.CombineLatest($email, $password)
        .map { $0.count > 2 && $1.count > 2 } // TODO: Check Format
        .eraseToAnyPublisher()

    // TODO: Validate Credentials
}
