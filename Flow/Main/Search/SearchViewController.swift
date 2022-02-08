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
        addResignKeyboardTapGesture()

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

        self.collectionView = SearchCollectionView(withFrame: view.bounds)
        collectionView.delegate = self
        view.addSubview(collectionView)
    }

    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ThumbnailCell, ImageItem> { cell, _, item in
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

    private func addResignKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(resignKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func resignKeyboard() {
        searchController.searchBar.endEditing(true)
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
}
