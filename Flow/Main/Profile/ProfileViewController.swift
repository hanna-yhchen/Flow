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

    private typealias ProfileDataSource = UICollectionViewDiffableDataSource<Section, Post>
    private typealias ProfileSnapshot = NSDiffableDataSourceSnapshot<Section, Post>

    // MARK: - Properties

    let userID: UserID
    let isCurrentUser: Bool
    let profileHeaderView: ProfileHeaderView

    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    var pages: [UIViewController] = []
    let segmentedControl = UISegmentedControl(items: ["Posts", "Mentioned"])
    var selectedIndex = 0 {
        didSet {
            print("selectedIndex is \(selectedIndex)")
        }
    }

    weak var delegate: ProfileViewControllerDelegate?

    // swiftlint:disable implicitly_unwrapped_optional
    private var dataSource: ProfileDataSource! = nil
    // swiftlint:enable implicitly_unwrapped_optional

    // MARK: - Lifecycle

    init(userID: UserID) {
        self.userID = userID
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
        navigationItem.title = "@username"

        configureHierarchy()
        configureDataSource()
    }

    private func configureHierarchy() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)

        pageViewController.delegate = self
        pageViewController.dataSource = self
        // pageViewController.isEditing = true
        add(child: pageViewController)
        guard let pageView = pageViewController.view else {
            return }
        pageView.translatesAutoresizingMaskIntoConstraints = false

        let vc0 = UIViewController()
        vc0.view.backgroundColor = .red
        vc0.view.tag = 0

        let vc1 = UIViewController()
        vc1.view.backgroundColor = .blue
        vc1.view.tag = 1

        pages = [vc0, vc1]
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: false)

        [profileHeaderView, segmentedControl].forEach { subview in
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
            // Seg & page
        ])

        profileHeaderView.nameLabel.text = "Name"
        profileHeaderView.profileImageView.image = UIImage(named: "keanu")
    }

    private func configureDataSource() {
    }

    // MARK: - Actions
    @objc private func segmentChanged(sender: UISegmentedControl) {
        let pageIndex = sender.selectedSegmentIndex
        let originalIndex = selectedIndex
        var direction: UIPageViewController.NavigationDirection = .forward
        if pageIndex < originalIndex {
            direction = .reverse
        }
        pageViewController.setViewControllers([pages[pageIndex]], direction: direction, animated: true) {[unowned self] completed in
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

        if finished && completed {
            selectedIndex = pageIndex
            segmentedControl.selectedSegmentIndex = selectedIndex
        }
    }
}

// MARK: - UIPageViewControllerDataSource

extension ProfileViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let originalIndex = pages.firstIndex(of: viewController),
            originalIndex > 0 else {
                print("viewControllerBefore <= 0")
                return nil
        }
        return pages[originalIndex - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let originalIndex = pages.firstIndex(of: viewController),
            originalIndex < 1 else {
                print("viewControllerAfter >= 1")
                return nil
        }
        return pages[originalIndex + 1]
    }
}
