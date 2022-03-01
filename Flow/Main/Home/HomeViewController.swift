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

    private func configureBindings() {
        Publishers
            .CombineLatest(viewModel.$posts, viewModel.$storybooks)
            .receive(on: RunLoop.main)
            .sink {[unowned self] posts, storybooks in
                self.posts = posts
                self.storybooks = storybooks
                dataSource.apply(currentSnapshot())
                // collectionView.reloadData()
            }
            .store(in: &subscriptions)
    }

    // MARK: - Methods

    func reload() {
        viewModel.reload()
    }
}

// MARK: - Data Source

extension HomeViewController {
    private func configureDataSource() {
        let storyCellRegistration = makeStoryCellRegistration()
        let feedCellRegistration = makeFeedCellRegistration()

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
        return UICollectionView.CellRegistration<StoryCell, Storybook> {[unowned self] cell, _, storybook in
            UserService.fetchUser(id: storybook.authorID) { author, error in
                if let error = error {
                    print("DEBUG: Error fetching user -", error.localizedDescription)
                }

                let profileImageURL = URL(string: author?.profileImageURL ?? "")
                cell.profileImageView.sd_setImage(with: profileImageURL)

                cell.usernameLabel.text = author?.username
            }

            if let currentUserID = viewModel.currentUserID {
                cell.isRead = storybook.whoHasReadAll.contains(currentUserID)
            }
        }
    }

    private func makeFeedCellRegistration() -> UICollectionView.CellRegistration<FeedCell, Post> {
        return UICollectionView.CellRegistration<FeedCell, Post> {[unowned self] cell, _, post in
            let imageURL = URL(string: post.imageURL)
            cell.postImageView.sd_setImage(with: imageURL)
            // Fetch author's profile image URL
            UserService.fetchUser(id: post.authorID) { author, error in
                if let error = error {
                    print("DEBUG: Error fetching user -", error.localizedDescription)
                }

                let profileImageURL = URL(string: author?.profileImageURL ?? "")
                cell.profileImageView.sd_setImage(with: profileImageURL)

                cell.nameLabel.text = author?.fullName
                cell.usernameLabel.text = author?.username
            }
            cell.captionLabel.text = post.caption

            if let currentUserID = viewModel.currentUserID {
                cell.didLike = post.whoLikes.contains(currentUserID)
                cell.didBookmark = post.whoBookmarks.contains(currentUserID)
            }


            cell.countOfLike = post.whoLikes.count
            cell.countOfComment = post.countOfComment
            cell.countOfBookmark = post.whoBookmarks.count

            cell.postID = post.id

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

            // TODO: Replace with a button covering caption and date in FeedCell
            let navigateToPost = UIAction {[unowned self] _ in
                self.delegate?.navigateToPost(post)
            }
            cell.coveringButton.addAction(navigateToPost, for: .touchUpInside)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
}
