//
//  ProfileViewController.swift
//  Flow
//
//  Created by Hanna Chen on 2022/2/8.
//

import UIKit
import Parchment
import Combine

protocol ProfileViewControllerDelegate: AnyObject {
    func navigateToPost(_ post: Post)
}

class ProfileViewController: UIViewController {
    enum Section {
        case thumbnail
    }

    private typealias ProfilePageDataSource = UICollectionViewDiffableDataSource<Section, Post>
    private typealias ProfilePageSnapshot = NSDiffableDataSourceSnapshot<Section, Post>

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
    private var mentionedCollectionView: UICollectionView! = nil
    private var postDataSource: ProfilePageDataSource! = nil
    private var mentionedDataSource: ProfilePageDataSource! = nil
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
        configureBindings()
        configureDataSource()
    }

    // MARK: - Configurations

    private func configureHierarchy() {
        // TODO: Add Underlay Scroll View
        addPages()

        let pagingViewController = PagingViewController(viewControllers: pages)
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
        self.mentionedCollectionView = GridCollectionView(withFrame: view.bounds)
        mentionedCollectionView.delegate = self
        bookmarkViewController.view = mentionedCollectionView
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
        self.mentionedDataSource = ProfilePageDataSource(collectionView: mentionedCollectionView) {
            collectionView, indexPath, item in
            return  collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }

        postDataSource.apply(currentPostSnapshot())
        mentionedDataSource.apply(currentMentionedSnapshot())
    }

    private func configureBindings() {
        viewModel.$profileImageURL
            .receive(on: RunLoop.main)
            .assign(to: \.profileImageURL, on: profileHeaderView)
            .store(in: &subscriptions)
        viewModel.$username
            .receive(on: RunLoop.main)
            .assign(to: \.title, on: navigationItem)
            .store(in: &subscriptions)
        viewModel.$fullName
            .receive(on: RunLoop.main)
            .assign(to: \.text, on: profileHeaderView.nameLabel)
            .store(in: &subscriptions)
        viewModel.$posts
            .assign(to: \.posts, on: self)
            .store(in: &subscriptions)
        viewModel.$bookmarks
            .assign(to: \.bookmarks, on: self)
            .store(in: &subscriptions)
    }

    // MARK: - Methods

    private func currentPostSnapshot() -> ProfilePageSnapshot {
        var snapshot = ProfilePageSnapshot()
        snapshot.appendSections([Section.thumbnail])
        snapshot.appendItems(posts)
        return snapshot
    }

    private func currentMentionedSnapshot() -> ProfilePageSnapshot {
        var snapshot = ProfilePageSnapshot()
        snapshot.appendSections([Section.thumbnail])
        snapshot.appendItems(bookmarks)
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
        case mentionedCollectionView:
            dataSource = mentionedDataSource
        default:
            fatalError("Unexpected collection view")
        }

        if let post = dataSource.itemIdentifier(for: indexPath) {
            delegate?.navigateToPost(post)
        }
    }
}
