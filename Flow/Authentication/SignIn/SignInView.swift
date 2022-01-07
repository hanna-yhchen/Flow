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
        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureStackView() {
        [emailTextField, passwordTextField].forEach { view in
            inputStack.addArrangedSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                view.heightAnchor.constraint(equalToConstant: 40),
                view.widthAnchor.constraint(equalTo: inputStack.widthAnchor),
            ])
        }
    }

    private func addSubviews() {
        [inputStack, forgotPasswordButton, authButton, goRegisterButton].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            inputStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            inputStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 40),
            inputStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -40),
            forgotPasswordButton.topAnchor.constraint(equalTo: inputStack.bottomAnchor, constant: 10),
            forgotPasswordButton.rightAnchor.constraint(equalTo: inputStack.rightAnchor),
            forgotPasswordButton.heightAnchor.constraint(equalToConstant: 20),
            authButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 20),
            authButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            authButton.widthAnchor.constraint(equalTo: inputStack.widthAnchor),
            authButton.heightAnchor.constraint(equalToConstant: 40),
            goRegisterButton.topAnchor.constraint(equalTo: authButton.bottomAnchor, constant: 20),
            goRegisterButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}
