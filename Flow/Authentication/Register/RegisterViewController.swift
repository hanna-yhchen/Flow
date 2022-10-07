//
//  RegisterViewController.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/6.
//

import UIKit
import Combine

protocol RegisterViewControllerDelegate: AnyObject {
    func registerDidComplete(_ controller: RegisterViewController)
}

class RegisterViewController: UIViewController {
    // MARK: - Properties

    weak var delegate: RegisterViewControllerDelegate?
    private let scrollView = UIScrollView()
    private let contentView = RegisterView()
    private let viewModel = RegisterViewModel()
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureKeyboardBehavior()
        configureTargets()
        configureBindings()
    }

    // MARK: - Configuration

    private func configureHierarchy() {
        scrollView.backgroundColor = .systemBackground
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.inputStack.arrangedSubviews.forEach { textField in
            (textField as? UITextField)?.delegate = self
        }

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        let scrollContentLayoutGuide = scrollView.contentLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 620),

            scrollContentLayoutGuide.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollContentLayoutGuide.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            scrollContentLayoutGuide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            scrollContentLayoutGuide.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])

        view.backgroundColor = .systemBackground
        navigationItem.title = "Register"
    }

    private func configureKeyboardBehavior() {
        keyboardFrameSubscription.store(in: &subscriptions)
        view.addResignKeyboardTapGesture()
    }

    private func configureTargets() {
        contentView.addPhotoButton.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        contentView.authButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        contentView.goSignInButton.addTarget(self, action: #selector(goSignIn), for: .touchUpInside)
    }

    private func configureBindings() {
        contentView.$profileImage
            .assign(to: \.profileImage, on: viewModel)
            .store(in: &subscriptions)
        contentView.emailTextField.textPublisher
            .assign(to: \.email, on: viewModel)
            .store(in: &subscriptions)
        contentView.passwordTextField.textPublisher
            .assign(to: \.password, on: viewModel)
            .store(in: &subscriptions)
        contentView.confirmPasswordTextField.textPublisher
            .assign(to: \.confirmPassword, on: viewModel)
            .store(in: &subscriptions)
        contentView.nameTextField.textPublisher
            .assign(to: \.fullName, on: viewModel)
            .store(in: &subscriptions)
        contentView.usernameTextField.textPublisher
            .assign(to: \.username, on: viewModel)
            .store(in: &subscriptions)

        viewModel.isInputValid
            .receive(on: DispatchQueue.main)
            .assign(to: \.isInputValid, on: contentView.authButton)
            .store(in: &subscriptions)
    }

    // MARK: - Actions

    @objc private func addPhoto() {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        picker.delegate = self
        picker.allowsEditing = true

        present(picker, animated: true, completion: nil)
    }

    @objc private func register() {
        contentView.authButton.isLoading = true
        viewModel.register {[unowned self] error in
            if let error = error {
                print("DEBUG: Error registering user -", error.localizedDescription)
                self.contentView.authButton.isLoading = false
                return
            }
            self.delegate?.registerDidComplete(self)
        }
    }

    @objc private func goSignIn() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        contentView.profileImage = selectedImage.withRenderingMode(.alwaysOriginal)
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate

extension RegisterViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let authTextField = textField as? AuthTextField {
            UIView.animate(withDuration: 0.2) {
                authTextField.bottomLine.backgroundColor = .secondaryLabel
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
        switch textField {
        case contentView.emailTextField:
            _ = contentView.passwordTextField.becomeFirstResponder()
        case contentView.passwordTextField:
            _ = contentView.confirmPasswordTextField.becomeFirstResponder()
        case contentView.confirmPasswordTextField:
            _ = contentView.nameTextField.becomeFirstResponder()
        case contentView.nameTextField:
            _ = contentView.usernameTextField.becomeFirstResponder()
        case contentView.usernameTextField:
            textField.resignFirstResponder()
            register()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}

// MARK: - KeyboardHandler

extension RegisterViewController: KeyboardHandler {
    func keyboardWillChangeFrame(yOffset: CGFloat, duration: TimeInterval, animationCurve: UIView.AnimationOptions) {
        // FIXME: The scrollView doesn't move simultaneously as the keyboard moves
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: -yOffset, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        UIView.animate(
            withDuration: duration,
            delay: TimeInterval(0),
            options: animationCurve,
            animations: { self.scrollView.layoutIfNeeded() },
            completion: nil
        )
    }
}
