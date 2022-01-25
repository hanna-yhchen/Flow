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
    let commentTextField = UITextField()

    init(profileImage: UIImage?) {
        super.init(frame: .zero)
        profileImageView.image = profileImage
        configure()
        print("init AddCommentView()")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        self.backgroundColor = .systemBackground
        separator.backgroundColor = .separator
        commentTextField.placeholder = "Add Comment..."
        commentTextField.returnKeyType = .send
        commentTextField.layer.borderColor = UIColor.separator.cgColor
        commentTextField.layer.borderWidth = 0.5
        commentTextField.layer.cornerRadius = 35 / 2

        let stack = UIStackView(arrangedSubviews: [profileImageView, commentTextField])
        stack.axis = .horizontal
        stack.spacing = 5
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: 35),
            profileImageView.widthAnchor.constraint(equalToConstant: 35),
        ])

        [separator, stack].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: topAnchor),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.5),

            stack.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 5),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
        ])
    }
}
