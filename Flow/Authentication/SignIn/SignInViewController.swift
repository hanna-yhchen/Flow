//
//  SignInViewController.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/3.
//

import UIKit
import Combine

protocol SignInViewControllerDelegate: AnyObject {
    func signInDidComplete(_ controller: SignInViewController)
    func navigateToRegister()
    func navigateToHelp()
}

class SignInViewController: UIViewController {
    // MARK: - Properties

    weak var delegate: SignInViewControllerDelegate?
    private let contentView = SignInView()
    private let viewModel = SignInViewModel()
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTargets()
        setupBindings()
    }

    override func loadView() {
        self.view = contentView
        navigationItem.title = "Welcome to Flow!"
        navigationItem.backButtonDisplayMode = .minimal

        contentView.inputStack.arrangedSubviews.forEach { textField in
            (textField as? UITextField)?.delegate = self
        }
    }

    // MARK: - Setup

    private func setupTargets() {
        contentView.authButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        contentView.goRegisterButton.addTarget(self, action: #selector(goRegister), for: .touchUpInside)
    }

    private func setupBindings() {
        contentView.emailTextField.textPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.email, on: viewModel)
            .store(in: &subscriptions)
        contentView.passwordTextField.textPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.password, on: viewModel)
            .store(in: &subscriptions)

        viewModel.isInputValid
            .receive(on: RunLoop.main)
            .assign(to: \.isInputValid, on: contentView)
            .store(in: &subscriptions)
    }

    // MARK: - Actions

    @objc private func signIn() {
        contentView.isLoading = true
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            self.contentView.isLoading = false
        }

        // TODO: Validate Credentials
    }

    @objc private func goRegister() {
        delegate?.navigateToRegister()
    }

    @objc private func forgotPasswordTapped() {
        delegate?.navigateToHelp()
    }
}

// MARK: - UITextFieldDelegate

extension SignInViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let authTextField = textField as? AuthTextField {
            UIView.animate(withDuration: 0.2) {
                authTextField.bottomLine.backgroundColor = .accentGray
                authTextField.bottomLineHeightConstraint.constant = 1.5
                authTextField.layoutIfNeeded()
            }
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let authTextField = textField as? AuthTextField {
            UIView.animate(withDuration: 0.2) {
                authTextField.bottomLine.backgroundColor = .systemGray
                authTextField.bottomLineHeightConstraint.constant = 1
                authTextField.layoutIfNeeded()
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == contentView.emailTextField {
            _ = contentView.passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            signIn()
        }
        return true
    }
}
