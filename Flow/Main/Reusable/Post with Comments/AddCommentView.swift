//
//  AddCommentView.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/20.
//

import UIKit

class AddCommentView: UIView {
    let separator = UIView()
    let profileImageView = UIImageView.filledCircle(length: 35)
    let commentTextView = GrowableTextView(placeholder: "Add a comment...")

    init(profileImage: UIImage?) {
        super.init(frame: .zero)
        profileImageView.image = profileImage
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        self.backgroundColor = .systemBackground
        separator.backgroundColor = .separator

        [separator, profileImageView, commentTextView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: topAnchor),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.5),

            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            profileImageView.heightAnchor.constraint(equalToConstant: 35),
            profileImageView.widthAnchor.constraint(equalToConstant: 35),

            commentTextView.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            commentTextView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 5),
            commentTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            commentTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            commentTextView.heightAnchor.constraint(lessThanOrEqualToConstant: commentTextView.maxHeight),
        ])
    }
}
