//
//  NewPostView.swift
//  
//
//  Created by Hanna Chen on 2022/2/21.
//

import UIKit

class NewPostView: UIView {
    // MARK: - Components

    var postImageView: UploadImageView = {
        let imageView = UploadImageView()
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    var captionTextView = CaptionTextView(placeholder: "Write a caption...")
    let activityIndicator = UIActivityIndicatorView(style: .large)

    // MARK: - Lifecycle

    init() {
        super.init(frame: .zero)
        backgroundColor = .systemBackground

        addSubviews()
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Configuration

    private func addSubviews() {
        [postImageView, captionTextView, activityIndicator].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            postImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            postImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            postImageView.widthAnchor.constraint(equalTo: widthAnchor),
            postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 3 / 4),

            captionTextView.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 20),
            captionTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            captionTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            captionTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),

            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
