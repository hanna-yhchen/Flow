//
//  NewPostViewController.swift
//  Flow
//
//  Created by Hanna Chen on 2022/2/21.
//

import UIKit
import PhotosUI
import Combine

protocol NewPostViewControllerDelegate: AnyObject {
    func didFinishNewPost(_ controller: NewPostViewController)
}

class NewPostViewController: UIViewController {
    // MARK: - Properties

    weak var delegate: NewPostViewControllerDelegate?
    private let scrollView = UIScrollView()
    private let contentView = NewPostView()

    private var keyboardFrameSubscription: AnyCancellable?

    // MARK: - LifeCycle

    init() {
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = "New Post"
        let cancelButton = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancelTapped)
        )
        navigationItem.leftBarButtonItem = cancelButton
        let shareButton = UIBarButtonItem(
            title: "Share",
            style: .done,
            target: self,
            action: #selector(shareTapped)
        )
        navigationItem.rightBarButtonItem = shareButton

        showImagePicker()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// We will get correct safe area insets here
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        configureHierarchy()
        configureKeyboardBehavior()
    }

    // MARK: - Configuration

    private func configureHierarchy() {
        contentView.captionTextView.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showImagePicker))
        contentView.postImageView.addGestureRecognizer(tapGesture)

        scrollView.backgroundColor = .systemBackground
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        let contentHeight = view.bounds.height - (view.safeAreaInsets.top + view.safeAreaInsets.bottom)
        let scrollContentLayoutGuide = scrollView.contentLayoutGuide

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: contentHeight),

            scrollContentLayoutGuide.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollContentLayoutGuide.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            scrollContentLayoutGuide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            scrollContentLayoutGuide.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])
    }

    private func configureKeyboardBehavior() {
        keyboardFrameSubscription = keyboardFrameSubscription()
        view.addResignKeyboardTapGesture()
    }

    // MARK: - Actions

    @objc private func showImagePicker() {
        // TODO: Allow user to edit photo
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }

    @objc private func cancelTapped() {
        view.endEditing(true)
        contentView.postImageView.image = UIImage(
            systemName: "plus.viewfinder",
            withConfiguration: UIImage.SymbolConfiguration(weight: .ultraLight)
        )
        contentView.captionTextView.text = ""
        contentView.captionTextView.placeholderLabel.isHidden = false
    }

    @objc private func shareTapped() {
        // TODO: Upload New Post
        delegate?.didFinishNewPost(self)
    }
}

// MARK: - PHPickerViewControllerDelegate

extension NewPostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let provider = results.first?.itemProvider else { return }

        if provider.canLoadObject(ofClass: UIImage.self) {
            provider.loadObject(ofClass: UIImage.self) { image, _ in
                guard let image = image as? UIImage else { return }
                DispatchQueue.main.async {
                    self.contentView.postImageView.image = image
                    self.contentView.layoutIfNeeded()
                }
            }
        }
    }
}

// MARK: - UITextViewDelegate

extension NewPostViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let textView = textView as? CaptionTextView else { return }
        textView.placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

// MARK: - KeyboardHandler

extension NewPostViewController: KeyboardHandler {
    func keyboardWillChangeFrame(yOffset: CGFloat, duration: TimeInterval, animationCurve: UIView.AnimationOptions) {
        let bottomOffset = CGPoint(x: 0, y: -yOffset)
        scrollView.setContentOffset(bottomOffset, animated: true)
        UIView.animate(
            withDuration: duration,
            delay: TimeInterval(0),
            options: animationCurve,
            animations: { self.scrollView.layoutIfNeeded() },
            completion: nil
        )
    }
}
