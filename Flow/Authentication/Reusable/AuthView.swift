//
//  AuthView.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/7.
//

import UIKit

class AuthView: UIView {
    // MARK: - Components

    let inputStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 30
        return stackView
    }()

    let emailTextField: AuthTextField = {
        let textField = AuthTextField(placeholder: "Email Address", leftIconName: "envelope")

        textField.keyboardType = .emailAddress
        textField.textContentType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .next

        return textField
    }()

    let passwordTextField = PasswordTextField(placeholder: "Password")
    let authButton: AuthButton

    // MARK: - Lifecycle

    init(authButtonTitle: String) {
        self.authButton = AuthButton(title: authButtonTitle)
        super.init(frame: .zero)
        self.backgroundColor = .systemBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
