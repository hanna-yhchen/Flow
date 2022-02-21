//
//  NewPostViewController.swift
//  Flow
//
//  Created by Hanna Chen on 2022/2/21.
//

import UIKit
import PhotosUI

protocol NewPostViewControllerDelegate: AnyObject {
    func didFinishNewPost(_ controller: NewPostViewController)
}

class NewPostViewController: UIViewController {
    // MARK: - Properties

    weak var delegate: NewPostViewControllerDelegate?
    let contentView = NewPostView()

    // MARK: - LifeCycle

    init() {
        super.init(nibName: nil, bundle: nil)
        showImagePicker()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = contentView
        contentView.captionTextView.delegate = self
        navigationItem.title = "New Post"
        let selectButton = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectTapped))
        navigationItem.leftBarButtonItem = selectButton
        let shareButton = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(shareTapped))
        navigationItem.rightBarButtonItem = shareButton
    }

    // MARK: - Private

    private func showImagePicker() {
        // TODO: Allow user to edit photo
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }

    @objc private func selectTapped() {
        showImagePicker()
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
            provider.loadObject(ofClass: UIImage.self) { image, error in
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
        guard let textView = textView as? GrowableTextView else { return }
        textView.placeholderLabel.isHidden = !textView.text.isEmpty

        let isOversized = textView.contentSize.height >= textView.maxHeight
        textView.isScrollEnabled = isOversized
        textView.setNeedsUpdateConstraints()
    }
}
