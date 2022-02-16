//
//  NewPostFlowController.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/8.
//

import UIKit

class NewPostFlowController: UIViewController {
    // MARK: - Properties

    private let navigation: FNavigationController

    // MARK: - Lifecycle

    init(navigation: FNavigationController = FNavigationController()) {
        self.navigation = navigation

        super.init(nibName: nil, bundle: nil)
        add(child: navigation)
        showImagePicker()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func showImagePicker() {
        
    }
}
