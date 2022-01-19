//
//  StoryCell.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/14.
//

import UIKit

class StoryCell: UICollectionViewCell {
    var isRead = false {
        didSet {
            if isRead {
                profileImageView.layer.borderColor = UIColor.systemGray.cgColor
            } else {
                profileImageView.layer.borderColor = UIColor.tintColor.cgColor
            }
        }
    }

    let profileImageView = UIImageView.filledCircle(length: 70)
    let usernameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.borderColor = UIColor.tintColor.cgColor

        usernameLabel.font = .systemFont(ofSize: 12)

        [profileImageView, usernameLabel].forEach { view in
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            usernameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 3),
        ])
    }
}
