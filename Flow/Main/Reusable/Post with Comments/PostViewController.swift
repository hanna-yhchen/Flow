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

    private let viewModel: PostViewModel

    private var post: Post
    private var comments: [Comment] = []
    private var authorProfileImageURL: URL?
    private var subscriptions = Set<AnyCancellable>()

    private let collectionView: PostCollectionView
    private var dataSource: PostDataSource?
    private let addCommentView: AddCommentView
    private var bottomConstraint: NSLayoutConstraint?
    private var keyboardFrameSubscription: AnyCancellable?

    // MARK: - Lifecycle

    init(post: Post) {
        self.post = post
        self.viewModel = PostViewModel(post: post)
        self.collectionView = PostCollectionView()
        self.addCommentView = AddCommentView()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Someone's Post"

        configureHierarchy()
        configureBindings()
        configureDataSource()
        configureKeyboardBehavior()
    }

    // MARK: - Configuration

    private func configureHierarchy() {
        view.addSubview(collectionView)

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

    private func configureBindings() {
        Publishers
            .CombineLatest4(
                viewModel.$post,
                viewModel.$comments,
                viewModel.$authorProfileImageURL,
                viewModel.$userProfileImageURL
            )
            .receive(on: RunLoop.main)
            .sink {[unowned self] post, comments, authorProfileImageURL, userProfileImageURL in
                self.post = post
                self.comments = comments
                self.authorProfileImageURL = authorProfileImageURL
                self.addCommentView.profileImageURL = userProfileImageURL

                if authorProfileImageURL != nil && userProfileImageURL != nil {
                    self.collectionView.reloadData()
                }
            }
            .store(in: &subscriptions)
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
            return collectionView.dequeueConfiguredReusableCell(
                using: commentCellRegistration,
                for: indexPath,
                item: comment
            )
        }

        dataSource?.supplementaryViewProvider = { collectionView, _, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: postViewRegistration, for: indexPath)
        }

        dataSource?.apply(currentSnapshot())
    }

    private func currentSnapshot() -> PostSnapshot {
        var snapshot = PostSnapshot()
        snapshot.appendSections([Section.comment])
        snapshot.appendItems(comments)
        return snapshot
    }

    private func makePostViewRegistration() -> UICollectionView.SupplementaryRegistration<PostView> {
        return UICollectionView.SupplementaryRegistration<PostView>(elementKind: PostCollectionView.headerKind) {
            [unowned self] postView, _, _ in
            let imageURL = URL(string: post.imageURL)
            postView.postImageView.sd_setImage(with: imageURL)
            postView.profileImageView.sd_setImage(with: self.authorProfileImageURL)
            postView.captionLabel.text = self.post.caption

            if let currentUserID = UserService.currentUserID() {
                postView.didLike = self.post.whoLikes.contains(currentUserID)
                postView.didBookmark = self.post.whoBookmarks.contains(currentUserID)
            }

            postView.countOfLike = self.post.whoLikes.count
            postView.countOfBookmark = self.post.whoBookmarks.count
            postView.countOfComment = self.comments.count
        }
    }

    private func makeCommentCellRegistration() -> UICollectionView.CellRegistration<CommentCell, Comment> {
        return UICollectionView.CellRegistration<CommentCell, Comment> { cell, _, comment in
            cell.nameLabel.text = comment.authorID
        }
    }
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
