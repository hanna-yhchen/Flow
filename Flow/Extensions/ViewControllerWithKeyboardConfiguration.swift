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
    typealias UserInfo = [AnyHashable: Any]

    lazy var tap: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(resignKeyboard))
        recognizer.cancelsTouchesInView = false
        return recognizer
    }()
    var bottomConstraint: NSLayoutConstraint?
    var keyboardFrameSubscriber: AnyCancellable?

    /// A Boolean value that determines whether the bottom view moves up or down according to the keyboard's end position.
    var isBottomViewMovingWithKeyboard = false {
        didSet {
            if isBottomViewMovingWithKeyboard {
                keyboardFrameSubscriber?.cancel()
                keyboardFrameSubscriber = NotificationCenter.default
                    .publisher(for: UIResponder.keyboardWillChangeFrameNotification)
                    .compactMap(\.userInfo)
                    .receive(on: RunLoop.main)
                    .sink { userInfo in
                        self.keyboardWillChangeFrame(with: userInfo)
                    }
            } else {
                keyboardFrameSubscriber?.cancel()
            }
        }
    }

    /// A Boolean value that determines whether the keyboard will be dismissed when user touches outside of text input area.
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

    private func keyboardWillChangeFrame(with userInfo: [AnyHashable: Any]) {
        guard let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
            let animationCurveRaw = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue
        else { return }

        let endFrameY = endFrame.origin.y
        let animationCurve = UIView.AnimationOptions(rawValue: animationCurveRaw)

        if endFrameY >= UIScreen.main.bounds.size.height {
            bottomConstraint?.constant = 0.0
        } else {
            let safeAreaHeight = view.safeAreaInsets.bottom
            bottomConstraint?.constant = -(endFrame.size.height - safeAreaHeight)
        }

        UIView.animate(
            withDuration: TimeInterval(duration),
            delay: TimeInterval(0),
            options: animationCurve,
            animations: { self.view.layoutIfNeeded() },
            completion: nil)
    }
}
