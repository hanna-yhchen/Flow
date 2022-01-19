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

    // MARK: - Properties

    weak var delegate: FeedViewControllerDelegate?

    // swiftlint:disable implicitly_unwrapped_optional
    private var collectionView: UICollectionView! = nil
    private var dataSource: UICollectionViewDiffableDataSource<HomeSection, ImageItem>! = nil
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

        dataSource = UICollectionViewDiffableDataSource<HomeSection, ImageItem>(collectionView: collectionView) {
            collectionView, indexPath, item in

            guard let section = HomeSection(rawValue: indexPath.section) else {
                fatalError("Unexpected Home Section Index")
            }

            switch section {
            case .story:
                return collectionView.dequeueConfiguredReusableCell(
                    using: storyCellRegistration,
                    for: indexPath,
                    item: item
                )
            case .feed:
                return collectionView.dequeueConfiguredReusableCell(
                    using: feedCellRegistration,
                    for: indexPath,
                    item: item
                )
            }
        }

        dataSource.apply(currentSnapshot(), animatingDifferences: false)
    }

    private func configureBindings() {
    }

    private func currentSnapshot() -> NSDiffableDataSourceSnapshot<HomeSection, ImageItem> {
        // TODO: Fetch Popular Posts
        let array = Array(repeating: 0, count: 100)
        let testStories = array.map { _ in ImageItem(image: nil) }
        let textFeeds = array.map { _ in ImageItem(image: UIImage(named: "scenery")) }

        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, ImageItem>()
        snapshot.appendSections([HomeSection.story, HomeSection.feed])

        dataSource?.apply(snapshot)
        snapshot.appendItems(testStories, toSection: .story)
        snapshot.appendItems(textFeeds, toSection: .feed)
        return snapshot
    }

    // MARK: - Actions

    @objc private func postCaptionTapped(sender: UITapGestureRecognizer) {
        guard let captionLabel = sender.view as? UILabel else { return }
        print("\(captionLabel.tag)th cell label pressed")
    }

    // MARK: - Cell Registration Factory

    private func makeStoryCellRegistration() -> UICollectionView.CellRegistration<StoryCell, ImageItem> {
        return UICollectionView.CellRegistration<StoryCell, ImageItem> { cell, _, _ in
            cell.profileImageView.image = UIImage(named: "keanu")
        }
    }

    private func makeFeedCellRegistration() -> UICollectionView.CellRegistration<FeedCell, ImageItem> {
        return UICollectionView.CellRegistration<FeedCell, ImageItem> {cell, indexPath, item in
            cell.postImageView.image = UIImage(named: "scenery")
            cell.postID = item.identifier.uuidString

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
