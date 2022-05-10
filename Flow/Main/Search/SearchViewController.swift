//
//  SearchViewController.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/11.
//

import UIKit
import Combine
import SDWebImage

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
    private var dataSource: SearchDataSource! = nil
    // swiftlint:enable implicitly_unwrapped_optional

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addResignKeyboardTapGesture()

        configureHierarchy()
        configureDataSource()
        configureBindings()
    }

    // MARK: - Configuration

    private func configureHierarchy() {
        let searchController = UISearchController(searchResultsController: nil)
        // TODO: Add Results TableView Controller
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController = searchController

        // FIXME: SearchBar Increase the Height of Navigation Bar
        let searchBar = searchController.searchBar
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
            .sink {[unowned self] posts in
                self.posts = posts
                if !posts.isEmpty {
                    dataSource.apply(currentSnapshot())
                }
            }
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

    func reload() {
        viewModel.reload()
    }

    // MARK: - Private

    private func currentSnapshot() -> NSDiffableDataSourceSnapshot<Section, Post> {
        var snapshot = SearchSnapshot()
        snapshot.appendSections([Section.thumbnail])
        snapshot.appendItems(posts)
        return snapshot
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
