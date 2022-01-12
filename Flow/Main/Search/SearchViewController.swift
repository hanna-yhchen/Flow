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

        let searchBar = searchController.searchBar
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        searchBar.showsCancelButton = false

        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: makeLayout())
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        view.addSubview(collectionView)
        self.collectionView = collectionView

//        searchBar.backgroundColor = .systemBackground
//        searchBar.backgroundImage = UIImage()
//        searchBar.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(searchBar)
//        view.addSubview(collectionView)
//        NSLayoutConstraint.activate([
//            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
//            searchBar.widthAnchor.constraint(equalTo: view.widthAnchor),
//            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
//            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//        ])
    }

    // swiftlint:disable operator_usage_whitespace
    private func makeLayout() -> UICollectionViewLayout {
        // First group: Trailing Main with pair
        let mainItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(2/3),
                heightDimension: .fractionalHeight(1/1)
            )
        )
        mainItem.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)

        let pairItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/1),
                heightDimension: .fractionalHeight(1/2)
            )
        )
        pairItem.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)

        let pairGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1/1)
            ),
            subitem: pairItem,
            count: 2
        )

        let trailingMainWithPairGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/1),
                heightDimension: .fractionalWidth(2/3)
            ),
            subitems: [pairGroup, mainItem]
        )

        // Second & Fourth group: 3*2 grid

        let gridItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1/1)
            )
        )
        gridItem.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)

        let rowGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/1),
                heightDimension: .fractionalHeight(1/2)
            ),
            subitem: gridItem,
            count: 3
        )
        let gridGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/1),
                heightDimension: .fractionalWidth(2/3)
            ),
            subitem: rowGroup,
            count: 2
        )

        // Third group: Trailing Main with pair
        let leadingMainWithPairGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/1),
                heightDimension: .fractionalWidth(2/3)
            ),
            subitems: [mainItem, pairGroup]
        )

        let nestedGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/1),
                heightDimension: .fractionalWidth(8/3)),
            subitems: [
                trailingMainWithPairGroup,
                gridGroup,
                leadingMainWithPairGroup,
                gridGroup,
            ]
        )

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
