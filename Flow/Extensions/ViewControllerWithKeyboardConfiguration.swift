//
//  ViewControllerWithKeyboardConfiguration.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/27.
//

import UIKit
import Combine

/// Custom view controller with configuration of keyboard's behavior.
class ViewControllerWithKeyboardConfiguration: UIViewController {
    lazy var tap: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(resignKeyboard))
        recognizer.cancelsTouchesInView = false
        return recognizer
    }()

    var isKeyboardResignedOnTappedOutside = false {
        didSet {
            if isKeyboardResignedOnTappedOutside {
                self.view.addGestureRecognizer(tap)
            } else {
                self.view.removeGestureRecognizer(tap)
            }
        }
    }

    @objc private func resignKeyboard() {
        self.view.endEditing(true)
    }
}
