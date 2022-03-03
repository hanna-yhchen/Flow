//
//  PostViewController.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/19.
//

import UIKit
import Combine

protocol PostViewControllerDelegate: AnyObject {
    func navigateToProfile(_ authorID: UserID)
    func postNeedUpdate(_ post: Post)
}

extension PostViewControllerDelegate {
    func postNeedUpdate(_ post: Post) {} // Only implemented by Home Flow Controller
}

class PostViewController: UIViewController {
    enum Section {
        case comment
    }

    typealias PostDataSource = UICollectionViewDiffableDataSource<Section, Comment>
    typealias PostSnapshot = NSDiffableDataSourceSnapshot<Section, Comment>
    typealias PostView = PostCell

    // MARK: - Properties

    weak var delegate: PostViewControllerDelegate?
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
    @objc private func navigateToProfile(_ sender: UIButton) {
        if let contentView = sender.superview,
            let cell = contentView.superview as? PostCell,
            let authorID = cell.post?.authorID {
            delegate?.navigateToProfile(authorID)
        }
    }

    @objc private func likeTapped(_ button: PostInteractionButton) {
        // TODO: Refactor in a more concise way
        if let contentView = button.superview?.superview?.superview,
            let cell = contentView.superview as? PostCell,
            var post = cell.post {
            cell.didLike.toggle()
            if cell.didLike {
                cell.countOfLike += 1
            } else {
                cell.countOfLike -= 1
            }

            guard let currentUserID = viewModel.currentUserID else {
                print("DEBUG: Missing current user id")
                return
            }
            if cell.didLike {
                post.whoLikes.append(currentUserID)
            } else {
                post.whoLikes.removeAll { $0 == currentUserID }
            }

            PostService.update(post)
            delegate?.postNeedUpdate(post)
        }
    }

    @objc private func bookmarkTapped(_ button: PostInteractionButton) {
        if let contentView = button.superview?.superview?.superview,
            let cell = contentView.superview as? PostCell,
            var post = cell.post {
            cell.didBookmark.toggle()
            if cell.didBookmark {
                cell.countOfBookmark += 1
            } else {
                cell.countOfBookmark -= 1
            }

            guard let currentUserID = viewModel.currentUserID else {
                print("DEBUG: Missing current user id")
                return
            }
            if cell.didBookmark {
                post.whoBookmarks.append(currentUserID)
            } else {
                post.whoBookmarks.removeAll { $0 == currentUserID }
            }

            cell.post = post
            PostService.update(post)
            delegate?.postNeedUpdate(post)

            UserService.fetchCurrentUser { user, error in
                guard var user = user else { return }
                if let error = error {
                    print("DEBUG: error fetching current user -", error.localizedDescription)
                }
                if cell.didBookmark {
                    user.bookmarkedPosts.append(post.id)
                } else {
                    user.bookmarkedPosts.removeAll { $0 == post.id }
                }
                UserService.update(user)
            }
        }
    }
}

// MARK: - Data Source

extension PostViewController {
    private func configureDataSource() {
        let postViewRegistration = makePostViewRegistration()
        let commentCellRegistration = makeCommentCellRegistration()

        dataSource = PostDataSource(collectionView: collectionView) { collectionView, indexPath, comment in
            collectionView.dequeueConfiguredReusableCell(
                using: commentCellRegistration,
                for: indexPath,
                item: comment
            )
        }

        dataSource?.supplementaryViewProvider = { collectionView, _, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(using: postViewRegistration, for: indexPath)
        }

        dataSource?.apply(currentSnapshot())
    }

    private func currentSnapshot() -> PostSnapshot {
        var snapshot = PostSnapshot()
        snapshot.appendSections([Section.comment])
        snapshot.appendItems(comments)
        return snapshot
    }

    // MARK: - Cell Registration Factory

    private func makePostViewRegistration() -> UICollectionView.SupplementaryRegistration<PostView> {
        UICollectionView.SupplementaryRegistration<PostView>(elementKind: PostCollectionView.headerKind) {
            [unowned self] postView, _, _ in
            postView.currentUserID = viewModel.currentUserID
            postView.post = post

            postView.likeButton.addTarget(self, action: #selector(likeTapped(_:)), for: .touchUpInside)
            postView.bookmarkButton.addTarget(self, action: #selector(bookmarkTapped(_:)), for: .touchUpInside)
            postView.authorCoveringButton.addTarget(self, action: #selector(navigateToProfile(_:)), for: .touchUpInside)
        }
    }

    private func makeCommentCellRegistration() -> UICollectionView.CellRegistration<CommentCell, Comment> {
        UICollectionView.CellRegistration<CommentCell, Comment> { cell, _, comment in
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
