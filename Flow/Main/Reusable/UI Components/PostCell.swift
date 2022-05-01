//
//  PostCell.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/17.
//

import UIKit
import SDWebImage

class PostCell: UICollectionViewCell {
    enum Size {
        static let padding = CGFloat(10)
        static let profileImageLength = CGFloat(40)
        static let font = CGFloat(16)
        static let smallFont = CGFloat(14)
    }

    // MARK: - Properties

    var post: Post? {
        didSet {
            guard let post = post else { return }

            let postImageURL = URL(string: post.imageURL)
            self.postImageView.sd_setImage(with: postImageURL)

            UserService.fetchUser(id: post.authorID) { author, error in
                if let error = error {
                    print("DEBUG: Error fetching user -", error.localizedDescription)
                }

                let profileImageURL = URL(string: author?.profileImageURL ?? "")
                self.profileImageView.sd_setImage(with: profileImageURL)

                self.nameLabel.text = author?.fullName
                self.usernameLabel.text = author?.username
            }

            if let currentUserID = currentUserID {
                didLike = post.whoLikes.contains(currentUserID)
                didBookmark = post.whoBookmarks.contains(currentUserID)
            }

            self.captionLabel.text = post.caption
            self.countOfLike = post.whoLikes.count
            self.countOfComment = post.countOfComment
            self.countOfBookmark = post.whoBookmarks.count

            let date = Date(timeIntervalSince1970: post.timeIntervalSince1970)
            self.timeLabel.text = date.formatted(date: .abbreviated, time: .shortened)
        }
    }

    var currentUserID: UserID?

    var countOfLike = 0 {
        didSet {
            likeButton.count = countOfLike
        }
    }

    var countOfComment = 0 {
        didSet {
            commentButton.count = countOfComment
        }
    }

    var countOfBookmark = 0 {
        didSet {
            bookmarkButton.count = countOfBookmark
        }
    }

    var didLike = false {
        didSet {
            likeButton.isAdopted = didLike
        }
    }

    var didBookmark = false {
        didSet {
            bookmarkButton.isAdopted = didBookmark
        }
    }

    var hasUnreadStory = false {
        didSet {
            if hasUnreadStory {
                profileImageView.layer.borderWidth = 2
            } else {
                profileImageView.layer.borderWidth = 0
            }
        }
    }

    // MARK: - Top Components

    lazy var topStack: UIStackView = {
        let nameStack = UIStackView(arrangedSubviews: [
            nameLabel,
            usernameLabel,
        ])
        nameStack.axis = .vertical
        nameStack.alignment = .leading

        let authorStack = UIStackView(arrangedSubviews: [
            profileImageView,
            nameStack
        ])
        authorStack.axis = .horizontal
        authorStack.alignment = .center
        authorStack.spacing = 10

        let topStack = UIStackView(arrangedSubviews: [
            authorStack,
            reactionButton,
        ])
        topStack.axis = .horizontal
        topStack.alignment = .center

        return topStack
    }()

    let profileImageView: UIImageView = {
        let imageView = UIImageView.filledCircle(length: Size.profileImageLength)
        imageView.layer.borderColor = UIColor.tintColor.cgColor
        imageView.layer.borderWidth = 2.5
        imageView.isUserInteractionEnabled = true
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.medium
        return imageView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = .boldSystemFont(ofSize: Size.font)
        label.isUserInteractionEnabled = true
        return label
    }()

    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "@username"
        label.font = .systemFont(ofSize: Size.font)
        label.textColor = .secondaryLabel
        label.isUserInteractionEnabled = true
        return label
    }()

    let reactionButton: UIButton = {
        let button = UIButton(type: .custom)
        let icon = UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(pointSize: Size.font))
        button.setImage(icon, for: .normal)
        return button
    }()

    // MARK: - Middle Components

    let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.medium
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    // MARK: - Bottom Components

    lazy var bottomStack: UIStackView = {
        let bottomStack = UIStackView(arrangedSubviews: [
            interactionStack,
            captionLabel,
            timeLabel,
        ])
        bottomStack.axis = .vertical
        bottomStack.spacing = 3

        return bottomStack
    }()

    lazy var interactionStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            likeButton,
            commentButton,
            bookmarkButton,
            shareButton,
        ])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        return stack
    }()

    let likeButton = PostInteractionButton(
        iconName: "heart",
        filledIconName: "heart.fill",
        pointSize: Size.smallFont
    )
    let commentButton = PostInteractionButton(
        iconName: "bubble.left",
        pointSize: Size.smallFont
    )
    let bookmarkButton = PostInteractionButton(
        iconName: "bookmark",
        filledIconName: "bookmark.fill",
        pointSize: Size.smallFont
    )
    let shareButton = PostInteractionButton(
        iconName: "square.and.arrow.up",
        pointSize: Size.smallFont
    )

    // TODO: Limit caption height and show 'more' if needed
    let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: Size.font)
        return label
    }()

    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Size.smallFont)
        label.textColor = .secondaryLabel
        return label
    }()

    let authorCoveringButton = UIButton(type: .custom)
    let middleCoveringButton = UIButton(type: .custom)
    let bottomCoveringButton = UIButton(type: .custom)

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        shareButton.setTitle("", for: .normal)

        addSubviews()
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Configuration

    private func addSubviews() {
        [
            topStack,
            postImageView,
            bottomStack,
            authorCoveringButton,
            middleCoveringButton,
            bottomCoveringButton,
        ].forEach { view in
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            topStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            topStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Size.padding),
            topStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Size.padding),

            postImageView.topAnchor.constraint(equalTo: topStack.bottomAnchor, constant: Size.padding / 2),
            postImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            postImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            postImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3 / 4),

            bottomStack.topAnchor.constraint(equalTo: postImageView.bottomAnchor),
            bottomStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Size.padding),
            bottomStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Size.padding),
            bottomStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Size.padding),

            authorCoveringButton.topAnchor.constraint(equalTo: topStack.topAnchor),
            authorCoveringButton.leadingAnchor.constraint(equalTo: topStack.leadingAnchor),
            authorCoveringButton.bottomAnchor.constraint(equalTo: topStack.bottomAnchor),
            authorCoveringButton.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            middleCoveringButton.topAnchor.constraint(equalTo: postImageView.topAnchor),
            middleCoveringButton.leadingAnchor.constraint(equalTo: bottomStack.leadingAnchor),
            middleCoveringButton.bottomAnchor.constraint(equalTo: bottomStack.topAnchor),
            middleCoveringButton.trailingAnchor.constraint(equalTo: bottomStack.trailingAnchor),

            bottomCoveringButton.topAnchor.constraint(equalTo: interactionStack.bottomAnchor),
            bottomCoveringButton.leadingAnchor.constraint(equalTo: bottomStack.leadingAnchor),
            bottomCoveringButton.bottomAnchor.constraint(equalTo: bottomStack.bottomAnchor),
            bottomCoveringButton.trailingAnchor.constraint(equalTo: bottomStack.trailingAnchor),
        ])
    }
}
