//
//  RegisterView.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/6.
//

import UIKit

class RegisterView: AuthView {
    // MARK: - Components

    var profilePhoto: UIImage? {
        didSet {
            addPhotoButton.setImage(profilePhoto, for: .normal)
        }
    }

    let addPhotoButton: UIButton = {
        let button = UIButton(type: .custom)
        let icon = UIImage(systemName: "camera.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16))
        button.setImage(icon, for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 150 / 2
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.layer.masksToBounds = true
        return button
    }()

    let confirmPasswordTextField = PasswordTextField(placeholder: "Confirm Password")

    let fullNameTextField: AuthTextField = {
        let textField = AuthTextField(placeholder: "Full Name", leftIconName: "person")

        textField.textContentType = .name
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .words
        textField.returnKeyType = .next

        return textField
    }()

    let usernameTextField: AuthTextField = {
        let textField = AuthTextField(placeholder: "Username", leftIconName: "tag")

        textField.textContentType = .username
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.returnKeyType = .join

        return textField
    }()

    let goSignInButton = AuthNavigationButton(questionText: "Already have an Account?", destinationText: "Sign In")

    // MARK: - Lifecycle

    init() {
        super.init(authButtonTitle: "Register")
        configureStackView()
        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Configuration

    private func configureStackView() {
        let stackSubviews = [
            emailTextField,
            passwordTextField,
            confirmPasswordTextField,
            fullNameTextField,
            usernameTextField,
        ]
        stackSubviews.forEach { view in
            inputStack.addArrangedSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                view.heightAnchor.constraint(equalToConstant: 40),
                view.widthAnchor.constraint(equalTo: inputStack.widthAnchor),
            ])
        }
    }

    private func addSubviews() {
        [addPhotoButton, inputStack, authButton, goSignInButton].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            addPhotoButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            addPhotoButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 150),
            addPhotoButton.widthAnchor.constraint(equalToConstant: 150),
            inputStack.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 20),
            inputStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 40),
            inputStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -40),
            authButton.topAnchor.constraint(equalTo: inputStack.bottomAnchor, constant: 50),
            authButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            authButton.widthAnchor.constraint(equalTo: inputStack.widthAnchor),
            authButton.heightAnchor.constraint(equalToConstant: 40),
            goSignInButton.topAnchor.constraint(equalTo: authButton.bottomAnchor, constant: 20),
            goSignInButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}
