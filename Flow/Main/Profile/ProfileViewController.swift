//
//  ProfileViewController.swift
//  Flow
//
//  Created by Hanna Chen on 2022/2/8.
//

import UIKit
import Parchment

protocol ProfileViewControllerDelegate: AnyObject {
    func navigateToPost(id: String)
}

class ProfileViewController: UIViewController {
    enum Section {
        case thumbnail
    }

    private typealias ProfilePageDataSource = UICollectionViewDiffableDataSource<Section, PostThumbnail>
    private typealias ProfilePageSnapshot = NSDiffableDataSourceSnapshot<Section, PostThumbnail>

    // MARK: - Properties

    let user: User
    let isCurrentUser: Bool
    let profileHeaderView: ProfileHeaderView

    var pages: [UIViewController] = []

    weak var delegate: ProfileViewControllerDelegate?

    // swiftlint:disable implicitly_unwrapped_optional
    private var postCollectionView: UICollectionView! = nil
    private var mentionedCollectionView: UICollectionView! = nil
    private var postDataSource: ProfilePageDataSource! = nil
    private var mentionedDataSource: ProfilePageDataSource! = nil
    // swiftlint:enable implicitly_unwrapped_optional

    // MARK: - Lifecycle

    init(user: User) {
        self.user = user
        // TODO: Check currentUser
        self.isCurrentUser = false
        self.profileHeaderView = ProfileHeaderView(isCurrentUser: isCurrentUser)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "@" + user.username

        configureHierarchy()
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

        profileHeaderView.nameLabel.text = user.fullName
        profileHeaderView.profileImageView.image = UIImage(named: "keanu")
    }

    private func addPages() {
        let postViewController = UIViewController()
        self.postCollectionView = GridCollectionView(withFrame: view.bounds)
        postCollectionView.delegate = self
        postViewController.view = postCollectionView
        postViewController.view.backgroundColor = .red
        postViewController.title = "Posts"

        let mentionedViewController = UIViewController()
        self.mentionedCollectionView = GridCollectionView(withFrame: view.bounds)
        mentionedCollectionView.delegate = self
        mentionedViewController.view = mentionedCollectionView
        mentionedViewController.view.backgroundColor = .blue
        mentionedViewController.title = "Mentioned"

        self.pages = [postViewController, mentionedViewController]
    }

    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ThumbnailCell, PostThumbnail> { cell, _, post in
            // TODO: Fetch post's image
            cell.backgroundColor = .systemBackground
            cell.tag = Int(post.id) ?? 0
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

    // MARK: - Methods

    private func currentPostSnapshot() -> ProfilePageSnapshot {
        // TODO: Fetch User's Post List
        let array = Array(0..<100)
        let posts = array.map { int in
            PostThumbnail(id: String(int), thumbnailURL: "")
        }

        var snapshot = ProfilePageSnapshot()
        snapshot.appendSections([Section.thumbnail])
        snapshot.appendItems(posts)
        return snapshot
    }

    private func currentMentionedSnapshot() -> ProfilePageSnapshot {
        // TODO: Fetch User's Mentioned Post List
        let array = Array(0..<100)
        let posts = array.map { int in
            PostThumbnail(id: String(int), thumbnailURL: "")
        }

        var snapshot = ProfilePageSnapshot()
        snapshot.appendSections([Section.thumbnail])
        snapshot.appendItems(posts)
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
            delegate?.navigateToPost(id: post.id)
        }
    }
}
