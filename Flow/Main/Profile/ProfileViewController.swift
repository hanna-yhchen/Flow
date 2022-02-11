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

    weak var delegate: ProfileViewControllerDelegate?

    // swiftlint:disable implicitly_unwrapped_optional
    private var dataSource: ProfileDataSource! = nil
    // swiftlint:enable implicitly_unwrapped_optional


    // MARK: - Lifecycle
    init(userID: UserID) {
        self.userID = userID
        //TODO: Check currentUser
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
        view.addSubview(profileHeaderView)
        profileHeaderView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            profileHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileHeaderView.heightAnchor.constraint(greaterThanOrEqualToConstant: 600)
        ])

        profileHeaderView.nameLabel.text = "Name"
        profileHeaderView.profileImageView.image = UIImage(named: "keanu")
    }

    private func configureDataSource() {
    }
}
