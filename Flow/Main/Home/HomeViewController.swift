//
//  HomeViewController.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/8.
//

import UIKit
import Combine

protocol HomeViewControllerDelegate: AnyObject {
    func navigateToPost(_ post: Post)
    func navigateToProfile(_ authorID: UserID)
}

class HomeViewController: UIViewController {
    enum Item: Hashable {
        case storybook(Storybook)
        case post(Post)
    }

    private typealias HomeDataSource = UICollectionViewDiffableDataSource<HomeSection, Item>
    private typealias HomeSnapshot = NSDiffableDataSourceSnapshot<HomeSection, Item>

    // MARK: - Properties

    weak var delegate: HomeViewControllerDelegate?
    private let viewModel = HomeViewModel()
    private var posts: [Post] = []
    private var storybooks: [Storybook] = []

    // swiftlint:disable implicitly_unwrapped_optional
    private var collectionView: UICollectionView! = nil
    private var dataSource: HomeDataSource! = nil
    // swiftlint:enable implicitly_unwrapped_optional

    private var subscriptions = Set<AnyCancellable>()

    private var needUpdatePost = false

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Home"

        configureHierarchy()
        configureDataSource()
        configureBindings()

        collectionView.collectionViewLayout.invalidateLayout()
    }

    // MARK: - Configuration

    private func configureHierarchy() {
        self.collectionView = HomeCollectionView(withFrame: view.bounds)
        collectionView.delegate = self
        view.addSubview(collectionView)
    }

    private func configureBindings() {
        Publishers
            .CombineLatest(viewModel.$posts, viewModel.$storybooks)
            .receive(on: RunLoop.main)
            .sink {[unowned self] posts, storybooks in
                self.posts = posts
                self.storybooks = storybooks
                if needUpdatePost {
                    dataSource.applySnapshotUsingReloadData(currentSnapshot(), completion: nil)
                    needUpdatePost = false
                } else {
                    dataSource.apply(currentSnapshot())
                }
            }
            .store(in: &subscriptions)
    }

    // MARK: - Methods

    func reload() {
        viewModel.reload()
    }

    func update(_ post: Post) {
        self.needUpdatePost = true
        viewModel.update(post)
    }

    // MARK: - Actions

    @objc private func navigateToPost(_ sender: UIButton) {
        if let contentView = sender.superview,
            let cell = contentView.superview as? PostCell,
            let post = cell.post {
            delegate?.navigateToPost(post)
        }
    }

    @objc private func navigateToProfile(_ sender: UIButton) {
        if let contentView = sender.superview,
            let cell = contentView.superview as? PostCell,
            let authorID = cell.post?.authorID {
            delegate?.navigateToProfile(authorID)
        }
    }

    @objc private func likeTapped(_ button: PostInteractionButton) {
        // TODO: Make the value passed in a more concise way
        if let contentView = button.superview?.superview?.superview,
            let cell = contentView.superview as? PostCell,
            var post = cell.post {
            cell.didLike.toggle()
            if cell.didLike {
                cell.countOfLike += 1
            } else {
                cell.countOfLike -= 1
            }

            guard let currentUserID = viewModel.currentUserID else {
                print("DEBUG: Missing current user id")
                return
            }
            if cell.didLike {
                post.whoLikes.append(currentUserID)
            } else {
                post.whoLikes.removeAll { $0 == currentUserID }
            }

            if let index = posts.firstIndex(where: { $0.id == post.id }) {
                posts[index] = post
            }
            cell.post = post
            dataSource.apply(currentSnapshot())
            PostService.update(post)
        }
    }

    @objc private func bookmarkTapped(_ button: PostInteractionButton) {
        if let contentView = button.superview?.superview?.superview,
            let cell = contentView.superview as? PostCell,
            var post = cell.post {
            cell.didBookmark.toggle()
            if cell.didBookmark {
                cell.countOfBookmark += 1
            } else {
                cell.countOfBookmark -= 1
            }

            guard let currentUserID = viewModel.currentUserID else {
                print("DEBUG: Missing current user id")
                return
            }
            if cell.didBookmark {
                post.whoBookmarks.append(currentUserID)
            } else {
                post.whoBookmarks.removeAll { $0 == currentUserID }
            }

            if let index = posts.firstIndex(where: { $0.id == post.id }) {
                posts[index] = post
            }
            cell.post = post
            dataSource.apply(currentSnapshot())
            PostService.update(post)

            UserService.fetchCurrentUser { user, error in
                guard var user = user else { return }
                if let error = error {
                    print("DEBUG: error fetching current user -", error.localizedDescription)
                }
                if cell.didBookmark {
                    user.bookmarkedPosts.append(post.id)
                } else {
                    user.bookmarkedPosts.removeAll { $0 == post.id }
                }
                UserService.update(user)
                // TODO: Reload User Profile's Bookmarks
            }
        }
    }
}

// MARK: - Data Source

extension HomeViewController {
    private func configureDataSource() {
        let storyCellRegistration = makeStoryCellRegistration()
        let feedCellRegistration = makePostCellRegistration()

        dataSource = HomeDataSource(collectionView: collectionView) {
            collectionView, indexPath, item in
            switch item {
            case .storybook(let storybook):
                return collectionView.dequeueConfiguredReusableCell(
                    using: storyCellRegistration,
                    for: indexPath,
                    item: storybook
                )
            case .post(let post):
                return collectionView.dequeueConfiguredReusableCell(
                    using: feedCellRegistration,
                    for: indexPath,
                    item: post
                )
            }
        }

        dataSource.apply(currentSnapshot())
    }

    private func currentSnapshot() -> HomeSnapshot {
        var snapshot = HomeSnapshot()
        snapshot.appendSections(HomeSection.allCases)

        let postItems = posts.map { post in
            Item.post(post)
        }
        let storybookItems = storybooks.map { storybook in
            Item.storybook(storybook)
        }
        snapshot.appendItems(storybookItems, toSection: .storybook)
        snapshot.appendItems(postItems, toSection: .post)
        return snapshot
    }

    // MARK: - Cell Registration Factory

    private func makeStoryCellRegistration() -> UICollectionView.CellRegistration<StoryCell, Storybook> {
        UICollectionView.CellRegistration<StoryCell, Storybook> { cell, _, storybook in
            cell.storybook = storybook
            // add target
        }
    }

    private func makePostCellRegistration() -> UICollectionView.CellRegistration<PostCell, Post> {
        UICollectionView.CellRegistration<PostCell, Post> {[unowned self] cell, _, post in
            cell.currentUserID = viewModel.currentUserID
            cell.post = post

            cell.likeButton.addTarget(self, action: #selector(likeTapped(_:)), for: .touchUpInside)
            cell.bookmarkButton.addTarget(self, action: #selector(bookmarkTapped(_:)), for: .touchUpInside)
            cell.authorCoveringButton.addTarget(self, action: #selector(navigateToProfile(_:)), for: .touchUpInside)
            cell.middleCoveringButton.addTarget(self, action: #selector(navigateToPost(_:)), for: .touchUpInside)
            cell.bottomCoveringButton.addTarget(self, action: #selector(navigateToPost(_:)), for: .touchUpInside)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
}
