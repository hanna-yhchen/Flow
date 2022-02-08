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
    var isCurrentUser = false

    weak var delegate: ProfileViewControllerDelegate?

    // swiftlint:disable implicitly_unwrapped_optional
    private var collectionView: UICollectionView! = nil
    private var dataSource: ProfileDataSource! = nil
    // swiftlint:enable implicitly_unwrapped_optional


    // MARK: - Lifecycle
    init(userID: UserID) {
        self.userID = userID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Someone's Profile"

        configureHierarchy()
        configureDataSource()
    }

    private func configureHierarchy() {

    }

    private func configureDataSource() {

    }
}
