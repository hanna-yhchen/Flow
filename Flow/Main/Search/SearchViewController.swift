//
//  SearchViewController.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/11.
//

import UIKit
import Combine

protocol SearchViewControllerDelegate: AnyObject {
    func navigateToPost(_ post: Post)
}

class SearchViewController: UIViewController {
    enum Section {
        case thumbnail
    }

    private typealias SearchDataSource = UICollectionViewDiffableDataSource<Section, Post>
    private typealias SearchSnapshot = NSDiffableDataSourceSnapshot<Section, Post>

    // MARK: - Properties

    weak var delegate: SearchViewControllerDelegate?
    private let viewModel = SearchViewModel()
    private var posts: [Post] = []
    private var subscriptions = Set<AnyCancellable>()

    // swiftlint:disable implicitly_unwrapped_optional
    private var searchController: UISearchController! = nil
    private var collectionView: UICollectionView! = nil
    private var dataSource: UICollectionViewDiffableDataSource<Section, Post>! = nil
    // swiftlint:enable implicitly_unwrapped_optional

    // private let viewModel = SearchViewModel()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addResignKeyboardTapGesture()

        configureHierarchy()
        configureBindings()
        configureDataSource()
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
        let cellRegistration = UICollectionView.CellRegistration<ThumbnailCell, Post> { cell, _, post in
            cell.backgroundColor = .systemBackground
            if let url = URL(string: post.imageURL) {
                cell.imageView.sd_setImage(with: url)
            }
        }

        dataSource = UICollectionViewDiffableDataSource<Section, Post>(collectionView: collectionView) {
            collectionView, indexPath, item -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            return cell
        }

        dataSource.apply(currentSnapshot())
    }

    private func configureBindings() {
        viewModel.$posts
            .assign(to: \.posts, on: self)
            .store(in: &subscriptions)
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

    private func currentSnapshot() -> NSDiffableDataSourceSnapshot<Section, Post> {
        var snapshot = SearchSnapshot()
        snapshot.appendSections([Section.thumbnail])
        snapshot.appendItems(posts)
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
        if let post = dataSource.itemIdentifier(for: indexPath) {
            delegate?.navigateToPost(post)
        }
    }
}
