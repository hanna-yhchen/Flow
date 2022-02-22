//
//  PostViewController.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/19.
//

import UIKit
import Combine

class PostViewController: UIViewController {
    enum Section {
        case comment
    }

    typealias PostDataSource = UICollectionViewDiffableDataSource<Section, Comment>
    typealias PostSnapshot = NSDiffableDataSourceSnapshot<Section, Comment>
    typealias PostView = FeedCell

    // MARK: - Properties

    let post: Post

    private let collectionView: UICollectionView
    private var dataSource: PostDataSource?
    private var bottomConstraint: NSLayoutConstraint?
    private var keyboardFrameSubscription: AnyCancellable?

    // MARK: - Lifecycle

    init(post: Post) {
        self.post = post
        self.collectionView = PostCollectionView()
        super.init(nibName: nil, bundle: nil)

        collectionView.delegate = self
        configureDataSource()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Someone's Post"

        configureHierarchy()
        configureKeyboardBehavior()
    }

    // MARK: - Configuration

    private func configureHierarchy() {
        view.addSubview(collectionView)
        // TODO: Fetch Current User's Profile Image
        let addCommentView = AddCommentView(profileImage: UIImage(named: "keanu"))
        addCommentView.commentTextView.delegate = self

        [collectionView, addCommentView].forEach { subview in
            view.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: addCommentView.topAnchor),

            addCommentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addCommentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addCommentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 45),
        ])

        bottomConstraint = NSLayoutConstraint(
            item: addCommentView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: view.safeAreaLayoutGuide,
            attribute: .bottom,
            multiplier: 1,
            constant: 0
        )
        bottomConstraint?.isActive = true
    }

    private func configureKeyboardBehavior() {
        keyboardFrameSubscription = keyboardFrameSubscription()
        view.addResignKeyboardTapGesture()
    }

    // MARK: - Actions
}

    // MARK: - Data Source

extension PostViewController {
    private func configureDataSource() {
        let postViewRegistration = makePostViewRegistration()
        let commentCellRegistration = makeCommentCellRegistration()

        dataSource = PostDataSource(collectionView: collectionView) { collectionView, indexPath, comment in
            return collectionView.dequeueConfiguredReusableCell(using: commentCellRegistration, for: indexPath, item: comment)
        }

        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: postViewRegistration, for: indexPath)
        }

        dataSource?.apply(currentSnapshot(), animatingDifferences: false)
    }

    private func currentSnapshot() -> PostSnapshot {
        // TODO: Fetch Comments by postID
        let array = Array(0..<20)
        let comments = array.map { int in Comment(authorID: "\(int)", content: "Hello", date: Date()) }

        var snapshot = PostSnapshot()
        snapshot.appendSections([Section.comment])
        snapshot.appendItems(comments)
        return snapshot
    }

    private func makePostViewRegistration() -> UICollectionView.SupplementaryRegistration<PostView> {
        return UICollectionView.SupplementaryRegistration<PostView>(elementKind: PostCollectionView.headerKind) {
            [unowned self] postView, _, _ in
            postView.postImageView.image = UIImage(named: "scenery")
            postView.captionLabel.text = self.post.caption
            postView.didLike = self.post.whoLikes.contains("myUserID")
            postView.didBookmark = self.post.whoBookmarks.contains("myUserID")
            postView.countOfLike = self.post.whoLikes.count
            postView.countOfComment = self.post.comments.count
            postView.countOfBookmark = self.post.whoBookmarks.count
        }
    }

    private func makeCommentCellRegistration() -> UICollectionView.CellRegistration<CommentCell, Comment> {
        return UICollectionView.CellRegistration<CommentCell, Comment> { cell, indexPath, comment in
            cell.nameLabel.text = comment.authorID
        }
    }
}

// MARK: - UICollectionViewDelegate

extension PostViewController: UICollectionViewDelegate {
}

// MARK: - UITextViewDelegate

extension PostViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let textView = textView as? GrowableTextView else { return }
        textView.placeholderLabel.isHidden = !textView.text.isEmpty

        let isOversized = textView.contentSize.height >= textView.maxHeight
        textView.isScrollEnabled = isOversized
        textView.setNeedsUpdateConstraints()
    }
}

// MARK: - KeyboardHandler

extension PostViewController: KeyboardHandler {
    func keyboardWillChangeFrame(yOffset: CGFloat, duration: TimeInterval, animationCurve: UIView.AnimationOptions) {
        bottomConstraint?.constant = yOffset
        UIView.animate(
            withDuration: duration,
            delay: TimeInterval(0),
            options: animationCurve,
            animations: { self.view.layoutIfNeeded() },
            completion: nil
        )
    }
}
