//
//  UITextField+Publisher.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/4.
//

import UIKit
import Combine

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField }
            .compactMap(\.text)
            .eraseToAnyPublisher()
    }
}
