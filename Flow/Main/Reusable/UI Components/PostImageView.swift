//
//  PostImageView.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/17.
//

import UIKit

class PostImageView: UIImageView {
    override var image: UIImage? {
        didSet {
            /// Make the height scale aspect fit with respect to the given width.
            guard let image = image else { return }
            let ratio = image.size.height / image.size.width
            translatesAutoresizingMaskIntoConstraints = false
            heightAnchor.constraint(equalTo: widthAnchor, multiplier: ratio).isActive = true
        }
    }
}
