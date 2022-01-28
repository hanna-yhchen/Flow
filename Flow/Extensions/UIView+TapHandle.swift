//
//  UIView+TapHandle.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/28.
//

import UIKit

extension UIView {
    func addResignKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(resignKeyboard))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }

    @objc private func resignKeyboard() {
        endEditing(true)
    }
}
