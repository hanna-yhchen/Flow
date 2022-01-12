//
//  FeedViewController.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/8.
//

import UIKit
import Combine

protocol FeedViewControllerDelegate: AnyObject {
}

class FeedViewController: UIViewController {
    // MARK: - Properties

    weak var delegate: FeedViewControllerDelegate?
    private let contentView = UIView()
    // private let viewModel = FeedViewModel()
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTargets()
        configureBindings()
    }

    override func loadView() {
        self.view = contentView
        navigationItem.title = "Hello!"
    }

    private func configureTargets() {
    }

    private func configureBindings() {
    }
}
