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
    private let viewModel = RegisterViewModel()
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        print("Here is Feed View!")

        setupTargets()
        setupBindings()
    }

    override func loadView() {
        self.view = contentView
        navigationItem.title = "Hello!"
    }

    private func setupTargets() {
    }

    private func setupBindings() {
    }
}
