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
    func navigateToCommentOfPost(id: String)
}

class HomeViewController: UIViewController {
    enum Item: Hashable {
        case story(Storybook)
        case feed(Post)
    }

    typealias HomeDataSource = UICollectionViewDiffableDataSource<HomeSection, Item>
    typealias HomeSnapshot = NSDiffableDataSourceSnapshot<HomeSection, Item>

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
        configureBindings()
    }

    // MARK: - Configuration

    private func configureHierarchy() {
        self.collectionView = HomeCollectionView(withFrame: view.bounds)
        collectionView.delegate = self
        view.addSubview(collectionView)
    }

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

    private func configureBindings() {
    }

    private func currentSnapshot() -> HomeSnapshot {
        // TODO: Fetch Popular Posts
        let array = Array(0..<100)
        let storybooks = array.map { int in Item.story(Storybook(profileImageThumbnailURL: "", authorID: "\(int)", authorName: "Keanu")) }
        let feeds = array.map { int in
            Item.feed(
                Post(id: "\(int)", authorID: "", thumbnailURL: "", photoURLs: [], caption: "Test caption", date: Date(), whoLikes: [], comments: Comments(postID: "", list: []), whoBookmarks: []))
        }

        var snapshot = HomeSnapshot()
        snapshot.appendSections(HomeSection.allCases)
        snapshot.appendItems(storybooks, toSection: .story)
        snapshot.appendItems(feeds, toSection: .feed)
        return snapshot
    }

    // MARK: - Actions

    @objc private func postCaptionTapped(sender: UITapGestureRecognizer) {
        guard let captionLabel = sender.view as? UILabel else { return }
        print("\(captionLabel.tag)th cell label pressed")
    }

    // MARK: - Cell Registration Factory

    private func makeStoryCellRegistration() -> UICollectionView.CellRegistration<StoryCell, Storybook> {
        return UICollectionView.CellRegistration<StoryCell, Storybook> { cell, _, storybook in
            cell.profileImageView.image = UIImage(named: "keanu")
            cell.usernameLabel.text = storybook.authorName
        }
    }

    private func makeFeedCellRegistration() -> UICollectionView.CellRegistration<FeedCell, Post> {
        return UICollectionView.CellRegistration<FeedCell, Post> {cell, indexPath, post in
            cell.postImageView.image = UIImage(named: "scenery")
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

//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(captionLabelTapped))
//            cell.captionLabel.addGestureRecognizer(tapGesture)
//            cell.captionLabel.tag = indexPath.item
        }
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
}
