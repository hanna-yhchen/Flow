//
//  ProfileHeaderView.swift
//  Flow
//
//  Created by Hanna Chen on 2022/2/10.
//

import UIKit

class ProfileHeaderView: UIView {
    // MARK: - Properties
    let isCurrentUser: Bool

    var storyIsRead = false {
        didSet {
            if storyIsRead {
                profileImageView.layer.borderColor = UIColor.systemGray.cgColor
            } else {
                profileImageView.layer.borderColor = UIColor.tintColor.cgColor
            }
        }
    }

    var isFollowing = false {
        didSet {
            followButton.setNeedsUpdateConfiguration()
        }
    }

    // MARK: - Components
    let profileImageView: UIImageView = {
        let imageView = UIImageView.filledCircle(length: 120)
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.tintColor.cgColor
        return imageView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()

    let bioLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.text = "Here is a long description about this user to be displayed more than one line..."
        label.textAlignment = .center
        label.numberOfLines = 3
        return label
    }()

    private lazy var statStack: UIStackView = {
        let stack = UIStackView()
        [postStatButton, followerStatButton, followingStatButton].forEach { view in
            stack.addArrangedSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.widthAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true
        }
        stack.axis = .horizontal
        stack.spacing = 10

        return stack
    }()

    let postStatButton = ProfileStatButton(statName: "Posts")
    let followerStatButton = ProfileStatButton(statName: "Followers")
    let followingStatButton = ProfileStatButton(statName: "Following")

    private lazy var interactionStack: UIStackView = {
        let stack: UIStackView
        if isCurrentUser {
            stack = UIStackView(arrangedSubviews: [editButton])
        } else {
            stack = UIStackView(arrangedSubviews: [followButton, messageButton])
        }
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 5

        return stack
    }()

    let editButton = BorderedButton(title: "Edit Profile")

    lazy var followButton: UIButton = {
        let button = BorderedButton(title: "Follow")
        var config = button.configuration
        button.configurationUpdateHandler = {[unowned self] button in
            guard var config = button.configuration else { return }

            var attributedString: AttributedString
            if self.isFollowing {
                attributedString = AttributedString("Following")
            } else {
                attributedString = AttributedString("Follow")
            }
            attributedString.font = .boldSystemFont(ofSize: 18)
            attributedString.foregroundColor = .label
            config.attributedTitle = attributedString

            button.configuration = config
        }
        return button
    }()

    let messageButton = BorderedButton(title: "Message")

    // MARK: - Lifecycle
    init(isCurrentUser: Bool) {
        self.isCurrentUser = isCurrentUser
        super.init(frame: .zero)
        configure()
        addSubviews()
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Private Configuration
    private func configure() {
    }

    private func addSubviews() {
        [profileImageView, nameLabel, bioLabel, statStack, interactionStack].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 30),

            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),

            bioLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            bioLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            bioLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            bioLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),

            statStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            statStack.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 20),
            statStack.heightAnchor.constraint(equalToConstant: 40),

            interactionStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            interactionStack.topAnchor.constraint(equalTo: statStack.bottomAnchor, constant: 20),
            interactionStack.widthAnchor.constraint(equalTo: bioLabel.widthAnchor),
            interactionStack.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
