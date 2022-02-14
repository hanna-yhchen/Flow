//
//  ProfileViewController.swift
//  Flow
//
//  Created by Hanna Chen on 2022/2/8.
//

import UIKit

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

    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    var pages: [UIViewController] = []

    let segmentedControl = UnderlinedSegmentedControl(titles: ["Posts", "Mentioned"])
    var selectedIndex = 0 {
        willSet {
            if newValue != segmentedControl.selectedSegmentIndex {
                segmentedControl.selectedSegmentIndex = newValue
            }
        }
    }

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
        configurePageViewController()

        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)

        guard let pageView = pageViewController.view else {
            return }

        [profileHeaderView, segmentedControl, pageView].forEach { subview in
            view.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            profileHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            segmentedControl.topAnchor.constraint(equalTo: profileHeaderView.bottomAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 35),

            pageView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            pageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

        profileHeaderView.nameLabel.text = user.fullName
        profileHeaderView.profileImageView.image = UIImage(named: "keanu")
    }

    private func configurePageViewController() {
        let postViewController = UIViewController()
        self.postCollectionView = GridCollectionView(withFrame: view.bounds)
        postCollectionView.delegate = self
        postViewController.view = postCollectionView
        postViewController.view.backgroundColor = .red

        let mentionedViewController = UIViewController()
        self.mentionedCollectionView = GridCollectionView(withFrame: view.bounds)
        mentionedCollectionView.delegate = self
        mentionedViewController.view = mentionedCollectionView
        mentionedViewController.view.backgroundColor = .blue

        self.pages = [postViewController, mentionedViewController]
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: false)

        addChild(pageViewController)
        pageViewController.delegate = self
        pageViewController.dataSource = self
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

    @objc private func segmentChanged(sender: UnderlinedSegmentedControl) {
        let pageIndex = sender.selectedSegmentIndex
        let originalIndex = selectedIndex
        var direction: UIPageViewController.NavigationDirection = .forward
        if pageIndex < originalIndex {
            direction = .reverse
        }
        pageViewController.setViewControllers(
            [pages[pageIndex]],
            direction: direction,
            animated: true
        ) {[unowned self] completed in
            if completed {
                self.selectedIndex = pageIndex
            }
        }
    }
}

// MARK: - UIPageViewControllerDelegate

extension ProfileViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard let viewControllers = pageViewController.viewControllers,
            let lastViewController = viewControllers.last,
            let pageIndex = pages.firstIndex(of: lastViewController) else {
                return
        }

        // FIXME: Animation of segment is slower
        if finished && completed {
            selectedIndex = pageIndex
        }
    }
}

// MARK: - UIPageViewControllerDataSource

extension ProfileViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let originalIndex = pages.firstIndex(of: viewController),
            originalIndex > 0 else {
                return nil
        }
        return pages[originalIndex - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let originalIndex = pages.firstIndex(of: viewController),
            originalIndex < 1 else {
                return nil
        }
        return pages[originalIndex + 1]
    }
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
