//
//  SignInView.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/3.
//

import UIKit

class SignInView: AuthView {
    // MARK: - Components

    let forgotPasswordButton = AuthNavigationButton(destinationText: "Forgot password?")
    let goRegisterButton = AuthNavigationButton(questionText: "Don't have an Account?", destinationText: "Register")

    // MARK: - Lifecycle

    init() {
        super.init(authButtonTitle: "Sign In")
        configureStackView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    private func configureStackView() {
        [emailTextField, passwordTextField, authButton].forEach { view in
            inputStack.addArrangedSubview(view)
            view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }

        inputStack.insertArrangedSubview(forgotPasswordButton, at: 2)
        forgotPasswordButton.contentHorizontalAlignment = .trailing

        inputStack.addArrangedSubview(goRegisterButton)

        inputStack.setCustomSpacing(10, after: passwordTextField)
        inputStack.setCustomSpacing(20, after: authButton)

        inputStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(inputStack)

        NSLayoutConstraint.activate([
            inputStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            inputStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 40),
            inputStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -40),
        ])
    }
}
