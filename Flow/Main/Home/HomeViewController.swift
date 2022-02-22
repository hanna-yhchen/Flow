//
//  HomeViewController.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/8.
//

import UIKit
import Combine

protocol FeedViewControllerDelegate: AnyObject {
    func navigateToPost(id: String)
}

class HomeViewController: UIViewController {
    enum Item: Hashable {
        case story(Storybook)
        case feed(Post)
    }

    private typealias HomeDataSource = UICollectionViewDiffableDataSource<HomeSection, Item>
    private typealias HomeSnapshot = NSDiffableDataSourceSnapshot<HomeSection, Item>

    // MARK: - Properties

    weak var delegate: FeedViewControllerDelegate?

    // swiftlint:disable implicitly_unwrapped_optional
    private var collectionView: UICollectionView! = nil
    private var dataSource: HomeDataSource! = nil
    // swiftlint:enable implicitly_unwrapped_optional

    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Home"

        configureHierarchy()
        configureDataSource()
    }

    // MARK: - Configuration

    private func configureHierarchy() {
        self.collectionView = HomeCollectionView(withFrame: view.bounds)
        collectionView.delegate = self
        view.addSubview(collectionView)
    }

    // MARK: - Actions

    @objc private func postCaptionTapped(sender: UITapGestureRecognizer) {
        // TODO: Pass id and Post also
        delegate?.navigateToPost(id: "007")
    }
}

// MARK: - Data Source

extension HomeViewController {
    private func configureDataSource() {
        let storyCellRegistration = makeStoryCellRegistration()
        let feedCellRegistration = makeFeedCellRegistration()

        dataSource = HomeDataSource(collectionView: collectionView) {
            collectionView, indexPath, item in
            switch item {
            case .story(let storybook):
                return collectionView.dequeueConfiguredReusableCell(
                    using: storyCellRegistration,
                    for: indexPath,
                    item: storybook
                )
            case .feed(let post):
                return collectionView.dequeueConfiguredReusableCell(
                    using: feedCellRegistration,
                    for: indexPath,
                    item: post
                )
            }
        }

        dataSource.apply(currentSnapshot(), animatingDifferences: false)
    }

    private func currentSnapshot() -> HomeSnapshot {
        // TODO: Fetch Popular Posts
        let array = Array(0..<100)
        let storybooks = array.map { int in Item.story(Storybook(authorID: "\(int)", whoHasReadAll: [])) }
        let feeds = array.map { int in
            Item.feed(
                Post(id: "\(int)", authorID: "", photoURL: nil, caption: "Test caption", date: Date(), whoLikes: [], comments: Comments(postID: "", count: 0), whoBookmarks: []))
        }

        var snapshot = HomeSnapshot()
        snapshot.appendSections(HomeSection.allCases)
        snapshot.appendItems(storybooks, toSection: .story)
        snapshot.appendItems(feeds, toSection: .feed)
        return snapshot
    }

    // MARK: - Cell Registration Factory

    private func makeStoryCellRegistration() -> UICollectionView.CellRegistration<StoryCell, Storybook> {
        return UICollectionView.CellRegistration<StoryCell, Storybook> { cell, _, storybook in
            // TODO: Fetch author's profile Image and username by storybook.authorID
            cell.profileImageView.image = UIImage(named: "keanu")
            cell.usernameLabel.text = "Keanu"

            cell.isRead = storybook.whoHasReadAll.contains("myUserID")
        }
    }

    private func makeFeedCellRegistration() -> UICollectionView.CellRegistration<FeedCell, Post> {
        return UICollectionView.CellRegistration<FeedCell, Post> {cell, _, post in
            // TODO: Fetch author's profile Image and username by storybook.authorID
            // TODO: Fetch post's image by post.photoURLs[0]
            cell.postImageView.image = UIImage(named: "scenery")
            cell.captionLabel.text = post.caption
            cell.didLike = post.whoLikes.contains("myUserID")
            cell.didBookmark = post.whoBookmarks.contains("myUserID")
            cell.countOfLike = post.whoLikes.count
            cell.countOfComment = post.comments.count
            cell.countOfBookmark = post.whoBookmarks.count

            cell.postID = post.id

            // Configure cell actions
            cell.likeButton.addAction(
                UIAction {_ in
                    cell.didLike.toggle()
                    // Update whoLikes and count
                },
                for: .touchUpInside
            )

            cell.bookmarkButton.addAction(
                UIAction {_ in
                    cell.didBookmark.toggle()
                    // Update whoBookmarks and count
                },
                for: .touchUpInside
            )

            // TODO: Replace with a button covering caption and date in FeedCell
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.postCaptionTapped))
            cell.captionLabel.addGestureRecognizer(tapGesture)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
}
