//
//  ProfileHeaderView.swift
//  Flow
//
//  Created by Hanna Chen on 2022/2/10.
//

import UIKit

class ProfileHeaderView: UIView {
    // MARK: - Properties
    var storyIsRead = false {
        didSet {
            if storyIsRead {
                profileImageView.layer.borderColor = UIColor.systemGray.cgColor
            } else {
                profileImageView.layer.borderColor = UIColor.tintColor.cgColor
            }
        }
    }

    // MARK: - Components
    let profileImageView: UIImageView = {
        let imageView = UIImageView.filledCircle(length: 120)
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.tintColor.cgColor
        return imageView
    }()

    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()

    private lazy var statStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            postsButton,
            followersButton,
            followingButton,
        ])
        stack.axis = .horizontal
        stack.spacing = 20

        return stack
    }()

    let postsButton: UIButton = {
        var config = UIButton.Configuration.plain()
        // Use attributed title/subtitle instead
        config.subtitle = "Posts"
        config.title = "29"
        config.baseForegroundColor = .label
        config.titleAlignment = .center
        config.titlePadding = 10
        let button = UIButton(configuration: config)
        return button
    }()

    let followersButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.subtitle = "Followers"
        config.title = "113"
        config.titleAlignment = .center
        config.titlePadding = 10
        let button = UIButton(configuration: config)
        return button
    }()

    let followingButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.subtitle = "Following"
        config.title = "89"
        config.titleAlignment = .center
        config.titlePadding = 10
        let button = UIButton(configuration: config)
        return button
    }()
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        [profileImageView, usernameLabel, statStack].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 30),

            usernameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),

            statStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            statStack.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 20),
        ])
    }
}
