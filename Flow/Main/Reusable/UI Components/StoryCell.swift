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
        [profileImageView, usernameLabel].forEach { view in
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
        ])

        profileImageView.layer.borderWidth = 3
        profileImageView.layer.borderColor = UIColor.tintColor.cgColor
    }
}
