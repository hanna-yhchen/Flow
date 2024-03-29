//
//  RegisterView.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/6.
//

import UIKit

class RegisterView: AuthView {
    // MARK: - Components

    @Published var profileImage: UIImage? {
        didSet {
            addPhotoButton.setImage(profileImage, for: .normal)
        }
    }

    let addPhotoButton: UIButton = {
        let button = UIButton(type: .custom)

        let icon = UIImage(systemName: "camera.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16))
        button.setImage(icon, for: .normal)

        button.layer.borderWidth = 1
        button.layer.cornerRadius = 120 / 2
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.layer.masksToBounds = true

        return button
    }()

    let confirmPasswordTextField = PasswordTextField(placeholder: "Confirm Password")

    let nameTextField: AuthTextField = {
        let textField = AuthTextField(placeholder: "Name", leftIconName: "person")

        textField.textContentType = .name
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .words
        textField.returnKeyType = .next

        return textField
    }()

    let usernameTextField: AuthTextField = {
        let textField = AuthTextField(placeholder: "Username", leftIconName: "at")

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
        addConstraints()
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
            nameTextField,
            usernameTextField,
            authButton,
        ]
        stackSubviews.forEach { view in
            inputStack.addArrangedSubview(view)
            view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }

        inputStack.setCustomSpacing(50, after: usernameTextField)
        inputStack.setCustomSpacing(20, after: authButton)

        inputStack.addArrangedSubview(goSignInButton)
    }

    private func addSubviews() {
        [addPhotoButton, inputStack].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            addPhotoButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            addPhotoButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 120),
            addPhotoButton.widthAnchor.constraint(equalToConstant: 120),

            inputStack.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 20),
            inputStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 40),
            inputStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -40),
        ])
    }
}
