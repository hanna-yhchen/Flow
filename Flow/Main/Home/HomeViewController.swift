//
//  HomeViewController.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/8.
//

import UIKit
import Combine

protocol FeedViewControllerDelegate: AnyObject {
}

class HomeViewController: UIViewController {
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

    private func configureHierarchy() {
        self.collectionView = HomeCollectionView(withFrame: view.bounds)
        collectionView.delegate = self
        view.addSubview(collectionView)
    }

    private func configureDataSource() {
        let storyCellRegistration = UICollectionView.CellRegistration<ImageCell, ImageItem> { cell, indexPath, item in
            cell.bounds = CGRect(x: 0, y: 0, width: 75, height: 75)
            cell.imageView.layer.cornerRadius = 75 / 2
            cell.imageView.layer.borderWidth = 2
            cell.imageView.layer.borderColor = UIColor.red.cgColor
        }

        let feedCellRegistration = UICollectionView.CellRegistration<ImageCell, ImageItem> { cell, _, item in
            cell.imageView.image = item.image
        }

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
        let testStories = array.map { _ in ImageItem(image: UIImage(named: "scenery")) }
        let textFeeds = array.map { _ in ImageItem(image: UIImage(named: "scenery")) }

        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, ImageItem>()
        snapshot.appendSections([HomeSection.story, HomeSection.feed])

        dataSource?.apply(snapshot)
        snapshot.appendItems(testStories, toSection: .story)
        snapshot.appendItems(textFeeds, toSection: .feed)
        return snapshot
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
}
