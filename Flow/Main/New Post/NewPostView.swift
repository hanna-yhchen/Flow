//
//  NewPostView.swift
//  
//
//  Created by Hanna Chen on 2022/2/21.
//

import UIKit

class NewPostView: UIView {
    // MARK: - Components

    let postImageView = PostImageView()
    let captionTextView = GrowableTextView(placeholder: "Write a caption...")

    // MARK: - Lifecycle

    init() {
        super.init(frame: .zero)
        addSubviews()
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Configuration

    private func addSubviews() {
        [postImageView, captionTextView].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            postImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            postImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            /// postImageView's dimension will be set whenever the image is set

            captionTextView.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 20),
            captionTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            captionTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }
}
