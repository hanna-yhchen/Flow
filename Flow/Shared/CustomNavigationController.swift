//
//  CustomNavigationController.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/7.
//

import UIKit

class CustomNavigationController: UINavigationController {
    init() {
        super.init(nibName: nil, bundle: nil)

        let backIndicator = UIImage(systemName: "chevron.backward.circle")
        navigationBar.backIndicatorImage = backIndicator
        navigationBar.backIndicatorTransitionMaskImage = backIndicator
        navigationBar.prefersLargeTitles = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
