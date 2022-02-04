//
//  CommentCell.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/20.
//

import UIKit

class CommentCell: UICollectionViewListCell {
    // MARK: - Properties
    var countOfLike = 0 {
        didSet {
            likeButton.count = countOfLike
        }
    }

    var didLike = false {
        didSet {
            likeButton.isAdopted = didLike
        }
    }
    // MARK: - Components

    let profileImageView = UIImageView.filledCircle(length: 35)

    lazy var stack: UIStackView = {
        let nameStack = UIStackView(arrangedSubviews: [
            nameLabel,
            usernameLabel,
        ])
        nameStack.axis = .horizontal
        nameStack.alignment = .center
        nameStack.spacing = 10

        let bottomStack = UIStackView(arrangedSubviews: [
            timeLabel,
            likeButton,
        ])
        bottomStack.axis = .horizontal
        bottomStack.alignment = .center
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        bottomStack.heightAnchor.constraint(equalToConstant: 18).isActive = true

        let stack = UIStackView(arrangedSubviews: [
            nameStack,
            commentLabel,
            bottomStack,
        ])
        stack.axis = .vertical
        stack.alignment = .leading

        return stack
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = .boldSystemFont(ofSize: 16)
        label.isUserInteractionEnabled = true
        return label
    }()

    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "@username"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.isUserInteractionEnabled = true
        return label
    }()

    let commentLabel: UILabel = {
        let label = UILabel()

        label.text = "Some comment..\nSecond Line.."
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.isUserInteractionEnabled = true

        return label
    }()

    let timeLabel: UILabel = {
        let label = UILabel()

        let currentDateString = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
        label.text = currentDateString

        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel

        return label
    }()

    let likeButton = PostInteractionButton(
        iconName: "heart",
        filledIconName: "heart.fill",
        pointSize: 12
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        profileImageView.image = UIImage(named: "keanu")

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        [profileImageView, stack].forEach { view in
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            profileImageView.heightAnchor.constraint(equalToConstant: 35),
            profileImageView.widthAnchor.constraint(equalToConstant: 35),

            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            stack.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 5),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        ])
    }
}
