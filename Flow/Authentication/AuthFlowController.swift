//
//  AuthFlowController.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/3.
//

import UIKit

protocol AuthFlowControllerDelegate: AnyObject {
    func authFlowControllerDidFinish(_ flowController: UIViewController)
}

class AuthFlowController: UIViewController {
    // MARK: - Properties

    weak var delegate: AuthFlowControllerDelegate?
    private let navigation: FNavigationController

    // MARK: - Lifecycle

    init(navigation: FNavigationController = FNavigationController()) {
        self.navigation = navigation
        navigation.navigationBar.prefersLargeTitles = true

        super.init(nibName: nil, bundle: nil)
        add(child: navigation)
        showSignIn()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func showSignIn() {
        let signInVC = SignInViewController()
        signInVC.delegate = self
        navigation.show(signInVC, sender: self)
    }
}

// MARK: - SignInViewControllerDelegate

extension AuthFlowController: SignInViewControllerDelegate {
    func signInDidComplete(_ controller: SignInViewController) {
        delegate?.authFlowControllerDidFinish(self)
    }

    func navigateToRegister() {
        let registerVC = RegisterViewController()
        registerVC.delegate = self
        navigation.pushViewController(registerVC, animated: true)
    }
}

extension AuthFlowController: RegisterViewControllerDelegate {
    func registerDidComplete(_ controller: RegisterViewController) {
        delegate?.authFlowControllerDidFinish(self)
    }
}
