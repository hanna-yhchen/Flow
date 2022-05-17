//
//  ProfileViewController.swift
//  Flow
//
//  Created by Hanna Chen on 2022/2/8.
//

import UIKit
import Parchment
import Combine
import SDWebImage

protocol ProfileViewControllerDelegate: AnyObject {
    func navigateToPost(_ post: Post)
}

class ProfileViewController: UIViewController {
    enum Section {
        case thumbnail
    }

    private typealias ProfilePageDataSource = UICollectionViewDiffableDataSource<Section, Post>
    private typealias PostSnapshot = NSDiffableDataSourceSectionSnapshot<Post>

    // MARK: - Properties

    private let viewModel: ProfileViewModel
    private var posts: [Post] = []
    private var bookmarks: [Post] = []
    private var subscriptions = Set<AnyCancellable>()

    private let profileHeaderView: ProfileHeaderView
    private var pages: [UIViewController] = []

    weak var delegate: ProfileViewControllerDelegate?

    // swiftlint:disable implicitly_unwrapped_optional
    private var postCollectionView: UICollectionView! = nil
    private var bookmarkCollectionView: UICollectionView! = nil
    private var postDataSource: ProfilePageDataSource! = nil
    private var bookmarkDataSource: ProfilePageDataSource! = nil
    // swiftlint:enable implicitly_unwrapped_optional

    // MARK: - Lifecycle

    init(userID: UserID) {
        self.viewModel = ProfileViewModel(userID: userID)
        self.profileHeaderView = ProfileHeaderView(isCurrentUser: viewModel.isCurrentUser)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        configureHierarchy()
        configureDataSource()
        configureBindings()
    }

    // MARK: - Configurations

    private func configureHierarchy() {
        // TODO: Add Underlay Scroll View
        addPages()

        let pagingViewController = PagingViewController(viewControllers: pages)
        pagingViewController.backgroundColor = .systemBackground
        pagingViewController.selectedBackgroundColor = .systemBackground
        pagingViewController.menuBackgroundColor = .systemBackground
        pagingViewController.borderColor = .systemBackground
        pagingViewController.menuInteraction = .swipe
        pagingViewController.indicatorOptions = .visible(
            height: 1,
            zIndex: Int.max,
            spacing: UIEdgeInsets.zero,
            insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        )
        pagingViewController.indicatorColor = .label
        pagingViewController.selectedTextColor = .label
        pagingViewController.textColor = .secondaryLabel
        pagingViewController.font = .boldSystemFont(ofSize: 16)
        pagingViewController.selectedFont = .boldSystemFont(ofSize: 16)

        add(child: pagingViewController)
        addChild(pagingViewController)
        pagingViewController.didMove(toParent: self)

        guard let pagingView = pagingViewController.view else { return }
        pagingView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(profileHeaderView)
        profileHeaderView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            profileHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            pagingView.topAnchor.constraint(equalTo: profileHeaderView.bottomAnchor, constant: 10),
            pagingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pagingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pagingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func addPages() {
        let postViewController = UIViewController()
        self.postCollectionView = GridCollectionView(withFrame: view.bounds)
        postCollectionView.delegate = self
        postViewController.view = postCollectionView
        postViewController.title = "Posts"

        let bookmarkViewController = UIViewController()
        self.bookmarkCollectionView = GridCollectionView(withFrame: view.bounds)
        bookmarkCollectionView.delegate = self
        bookmarkViewController.view = bookmarkCollectionView
        bookmarkViewController.title = "Bookmarks"

        self.pages = [postViewController, bookmarkViewController]
    }

    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ThumbnailCell, Post> { cell, _, post in
            cell.backgroundColor = .systemBackground
            if let url = URL(string: post.imageURL) {
                cell.imageView.sd_setImage(with: url)
            }
        }

        self.postDataSource = ProfilePageDataSource(collectionView: postCollectionView) {
            collectionView, indexPath, item in
            return  collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        self.bookmarkDataSource = ProfilePageDataSource(collectionView: bookmarkCollectionView) {
            collectionView, indexPath, item in
            return  collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }

    private func configureBindings() {
        viewModel.$profileImageURL
            .receive(on: DispatchQueue.main)
            .assign(to: \.profileImageURL, on: profileHeaderView)
            .store(in: &subscriptions)
        viewModel.$username
            .receive(on: DispatchQueue.main)
            .assign(to: \.title, on: navigationItem)
            .store(in: &subscriptions)
        viewModel.$fullName
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: profileHeaderView.nameLabel)
            .store(in: &subscriptions)

        Publishers
            .CombineLatest(viewModel.$posts, viewModel.$bookmarks)
            .receive(on: DispatchQueue.main)
            .sink {[unowned self] posts, bookmarks in
                self.posts = posts
                self.bookmarks = bookmarks
                // TODO: Show real bio
                profileHeaderView.postStatButton.count = posts.count
                // TODO: Add follow functionality and show real stat
                profileHeaderView.followerStatButton.count = 17
                profileHeaderView.followingStatButton.count = 21
                postDataSource.apply(currentPostSnapshot(), to: .thumbnail)
                bookmarkDataSource.apply(currentBookmarkSnapshot(), to: .thumbnail)
            }
            .store(in: &subscriptions)
    }

    // MARK: - Methods

    func reload() {
        viewModel.reload()
    }

    // MARK: - Private

    private func currentPostSnapshot() -> PostSnapshot {
        var snapshot = PostSnapshot()
        snapshot.append(posts)
        return snapshot
    }

    private func currentBookmarkSnapshot() -> PostSnapshot {
        var snapshot = PostSnapshot()
        snapshot.append(bookmarks)
        return snapshot
    }

    // MARK: - Actions

}

// MARK: - UICollectionViewDelegate

extension ProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var dataSource: ProfilePageDataSource

        switch collectionView {
        case postCollectionView:
            dataSource = postDataSource
        case bookmarkCollectionView:
            dataSource = bookmarkDataSource
        default:
            fatalError("Unexpected collection view")
        }

        if let post = dataSource.itemIdentifier(for: indexPath) {
            delegate?.navigateToPost(post)
        }
    }
}
