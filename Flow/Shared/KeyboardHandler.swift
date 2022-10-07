//
//  KeyboardHandler.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/28.
//

import UIKit
import Combine

protocol KeyboardHandler: AnyObject {
    var keyboardFrameSubscription: AnyCancellable { get }
    var bottomInset: CGFloat { get }
    func keyboardWillChangeFrame(yOffset: CGFloat, duration: TimeInterval, animationCurve: UIView.AnimationOptions)
}

extension KeyboardHandler where Self: UIViewController {
    var keyboardFrameSubscription: AnyCancellable {
        return NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .compactMap(\.userInfo)
            .receive(on: DispatchQueue.main)
            .sink {[weak self] userInfo in
                self?.handle(userInfo: userInfo)
            }
    }

    var bottomInset: CGFloat {
        view.safeAreaInsets.bottom
    }

    private func handle(userInfo: [AnyHashable: Any]) {
        guard let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration: TimeInterval =
                (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
            let animationCurveRaw = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue
        else { return }

        let endFrameY = endFrame.origin.y
        let animationCurve = UIView.AnimationOptions(rawValue: animationCurveRaw)

        var yOffset = CGFloat(0)
        if endFrameY < UIScreen.main.bounds.size.height {
            yOffset = -(endFrame.size.height - bottomInset)
        }

        keyboardWillChangeFrame(yOffset: yOffset, duration: duration, animationCurve: animationCurve)
    }
}
