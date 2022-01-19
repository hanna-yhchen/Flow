//
//  UIImageView+FilledCircleFactory.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/17.
//

import UIKit

extension UIImageView {
    static func filledCircle(length: CGFloat) -> UIImageView {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = length / 2

        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: length),
            imageView.widthAnchor.constraint(equalToConstant: length),
        ])

        return imageView
    }
}
