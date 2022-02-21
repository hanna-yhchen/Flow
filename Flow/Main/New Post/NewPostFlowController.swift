//
//  NewPostFlowController.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/8.
//

import UIKit

protocol NewPostFlowControllerDelegate: AnyObject {
    func newPostFlowControllerDidFinish(_ flowController: UIViewController)
}

class NewPostFlowController: UIViewController {
    // MARK: - Properties

    weak var delegate: NewPostFlowControllerDelegate?
    private let navigation: FNavigationController
    var didFinish = true

    // MARK: - Lifecycle

    init(navigation: FNavigationController = FNavigationController()) {
        self.navigation = navigation

        super.init(nibName: nil, bundle: nil)
        add(child: navigation)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showNewPost() {
        didFinish = false
        let newPostVC = NewPostViewController()
        newPostVC.delegate = self
        navigation.show(newPostVC, sender: self)
    }
}

// MARK: - NewPostViewControllerDelegate

extension NewPostFlowController: NewPostViewControllerDelegate {
    func didFinishNewPost(_ controller: NewPostViewController) {
        didFinish = true
        remove(child: controller)
        delegate?.newPostFlowControllerDidFinish(self)
    }
}
