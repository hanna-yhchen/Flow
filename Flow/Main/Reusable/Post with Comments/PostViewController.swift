//
//  PostViewController.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/19.
//

import UIKit

class PostViewController: UIViewController {
    enum Section {
        case comment
    }

    typealias PostDataSource = UICollectionViewDiffableDataSource<Section, Comment>
    typealias PostSnapshot = NSDiffableDataSourceSnapshot<Section, Comment>
    typealias PostView = FeedCell

    // MARK: - Properties

    let post: Post
    let postID: String

    private let collectionView: UICollectionView
    private var dataSource: PostDataSource?

    // MARK: - Lifecycle

    init(postID: String, post: Post) {
        self.post = post
        self.postID = postID
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
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            addCommentView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            addCommentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addCommentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addCommentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 45),
            addCommentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

        hideKeyboardWhenTappedAround()
    }

    // MARK: - Actions


    // MARK: - Helpers
    private func hideKeyboardWhenTappedAround() {
        let tapAround = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapAround.cancelsTouchesInView = false
        view.addGestureRecognizer(tapAround)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
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
        snapshot.appendItems(comments, toSection: .comment)
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
            cell.backgroundColor = .systemBackground
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
