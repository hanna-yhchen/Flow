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
            }
            .store(in: &subscriptions)
    }

    // MARK: - Methods

    func reload() {
        viewModel.reload()
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
        UICollectionView.CellRegistration<PostCell, Post> { cell, _, post in
            cell.post = post

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

            cell.authorCoveringButton.addTarget(self, action: #selector(self.navigateToProfile), for: .touchUpInside)
            cell.middleCoveringButton.addTarget(self, action: #selector(self.navigateToPost), for: .touchUpInside)
            cell.bottomCoveringButton.addTarget(self, action: #selector(self.navigateToPost), for: .touchUpInside)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
}
