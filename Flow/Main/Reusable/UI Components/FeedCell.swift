//
//  FeedCell.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/17.
//

import UIKit

class FeedCell: UICollectionViewCell {
    enum Size {
        static let padding = CGFloat(10)
        static let profileImageLength = CGFloat(40)
        static let font = CGFloat(16)
        static let smallFont = CGFloat(14)
    }

    // MARK: - Properties
    var postID = ""

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
            authorNameLabel,
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
        return imageView
    }()

    let authorNameLabel: UILabel = {
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
        // TODO: Add Action to Show Menu
        return button
    }()

    // MARK: - Middle Components

    let postImageView: UIImageView = {
        let imageView = PostImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    // MARK: - Bottom Components

    lazy var bottomStack: UIStackView = {
        let interactionStack = UIStackView(arrangedSubviews: [
            likeButton,
            commentButton,
            bookmarkButton,
            shareButton,
        ])
        interactionStack.axis = .horizontal
        interactionStack.distribution = .fillEqually
        interactionStack.alignment = .center

        let bottomStack = UIStackView(arrangedSubviews: [
            interactionStack,
            captionLabel,
            timeLabel,
        ])
        bottomStack.axis = .vertical
        bottomStack.spacing = 3

        return bottomStack
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

    // TODO: Make Caption Expandable
    let captionLabel: UILabel = {
        let label = UILabel()

        label.text = "Some captions.."
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: Size.font)
        label.isUserInteractionEnabled = true

        return label
    }()

    let timeLabel: UILabel = {
        let label = UILabel()

        let currentDateString = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
        label.text = currentDateString

        label.font = .systemFont(ofSize: Size.smallFont)
        label.textColor = .secondaryLabel

        return label
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        shareButton.setTitle("", for: .normal)
        profileImageView.image = UIImage(named: "keanu")

        addSubviews()
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Configuration

    private func addSubviews() {
        [topStack, postImageView, bottomStack].forEach { view in
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
            postImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            // height will be set whenever image is set

            bottomStack.topAnchor.constraint(equalTo: postImageView.bottomAnchor),
            bottomStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Size.padding),
            bottomStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Size.padding),
            bottomStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
