//
//  SearchViewController.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/11.
//

import UIKit
import Combine

protocol SearchViewControllerDelegate: AnyObject {
}

class SearchViewController: UIViewController {
    // MARK: - Properties

    enum Section {
        case main
    }

    weak var delegate: SearchViewControllerDelegate?
    // swiftlint:disable implicitly_unwrapped_optional
    private var searchController: UISearchController! = nil
    private var collectionView: UICollectionView! = nil
    private var dataSource: UICollectionViewDiffableDataSource<Section, ImageItem>! = nil
    // swiftlint:enable implicitly_unwrapped_optional
    // private let viewModel = SearchViewModel()
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        configureHierarchy()
        configureDataSource()
        configureTargets()
        configureBindings()
    }

    // MARK: - Configuration

    private func configureHierarchy() {
        let searchController = UISearchController(searchResultsController: nil)
        // TODO: Add Results TableView Controller
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController = searchController

        // FIXME: SearchBar Increase the Height of Navigation Bar
        let searchBar = searchController.searchBar
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        self.navigationItem.titleView = searchBar

        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: makeLayout())
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        view.addSubview(collectionView)
        self.collectionView = collectionView
    }

    // swiftlint:disable operator_usage_whitespace
    private func makeLayout() -> UICollectionViewLayout {
        let fullWidth = view.bounds.width
        let smallItemLength = (fullWidth - 2) / 3
        let largeItemLength = fullWidth - smallItemLength - 1

        let smallItemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(smallItemLength),
            heightDimension: .absolute(smallItemLength)
        )
        let largeItemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(largeItemLength),
            heightDimension: .absolute(largeItemLength)
        )
        let verticalPairSize = NSCollectionLayoutSize(
            widthDimension: .absolute(smallItemLength),
            heightDimension: .absolute(largeItemLength)
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(fullWidth),
            heightDimension: .absolute(largeItemLength)
        )

        let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)
        let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)
        let verticalPair = NSCollectionLayoutGroup.vertical(
            layoutSize: verticalPairSize,
            subitem: smallItem,
            count: 2
        )
        verticalPair.interItemSpacing = .fixed(1)

        let trailingLargeWithPairGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [verticalPair, largeItem]
        )
        trailingLargeWithPairGroup.interItemSpacing = .fixed(1)

        let triplePairGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: verticalPair,
            count: 3
        )
        triplePairGroup.interItemSpacing = .fixed(1)

        let leadingLargeWithPairGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [largeItem, verticalPair]
        )
        leadingLargeWithPairGroup.interItemSpacing = .fixed(1)

        let nestedGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(4 * (largeItemLength +  1))
            ),
            subitems: [
                trailingLargeWithPairGroup,
                triplePairGroup,
                leadingLargeWithPairGroup,
                triplePairGroup,
            ]
        )
        nestedGroup.interItemSpacing = .fixed(1)

        let section = NSCollectionLayoutSection(group: nestedGroup)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ImageCell, ImageItem> { cell, _, item in
            cell.imageView.image = item.image
        }

        dataSource = UICollectionViewDiffableDataSource<Section, ImageItem>(collectionView: collectionView) {
            collectionView, indexPath, item -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            return cell
        }

        dataSource.apply(currentSnapshot(), animatingDifferences: false)
    }

    private func configureTargets() {
    }

    private func configureBindings() {
    }

    // MARK: - Methods

    private func currentSnapshot() -> NSDiffableDataSourceSnapshot<Section, ImageItem> {
        // TODO: Fetch Popular Posts
        let array = Array(repeating: 0, count: 100)
        let testItems = array.map { _ in ImageItem(image: UIImage(named: "scenery")) }
        var snapshot = NSDiffableDataSourceSnapshot<Section, ImageItem>()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(testItems)
        return snapshot
    }
}

// MARK: - UISearchControllerDelegate & UISearchBarDelegate

extension SearchViewController: UISearchControllerDelegate, UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        // TODO: Add animation
    }
}

// MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
