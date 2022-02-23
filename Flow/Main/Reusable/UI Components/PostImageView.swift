//
//  PostImageView.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/17.
//

import UIKit

class PostImageView: UIImageView {
    // swiftlint:disable line_length
    lazy var widthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
    lazy var heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
    lazy var placeholderImageView: UIImageView = {
        let placeholder = UIImageView()
        placeholder.image = UIImage(
            systemName: "plus.viewfinder",
            withConfiguration: UIImage.SymbolConfiguration(weight: .ultraLight)
        )
        self.addSubview(placeholder)
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeholder.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeholder.centerYAnchor.constraint(equalTo: centerYAnchor),
            placeholder.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            placeholder.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
        ])
        placeholder.isHidden = true // only display in upload screen
        return placeholder
    }()

    override var image: UIImage? {
        didSet {
            /// Make the height scale aspect fit with respect to the given width.
            guard let image = image else { return }
            let ratio = image.size.height / image.size.width
            translatesAutoresizingMaskIntoConstraints = false

            let fullWidth = UIScreen.main.bounds.width
            widthConstraint.constant = fullWidth

            let maxHeight = fullWidth * ( 4 / 3 )
            let estimatedHeight = fullWidth * ratio
            if estimatedHeight > maxHeight {
                heightConstraint.constant = maxHeight
            } else {
                heightConstraint.constant = estimatedHeight
            }

            widthConstraint.isActive = true
            heightConstraint.isActive = true
            layoutIfNeeded()
        }
    }

    init() {
        super.init(frame: .zero)
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reset() {
        image = nil
        placeholderImageView.isHidden = false
        let fullWidth = UIScreen.main.bounds.width
        heightConstraint.constant = fullWidth * 0.8
        widthConstraint.constant = fullWidth * 0.8
        widthConstraint.isActive = true
        heightConstraint.isActive = true
        layoutIfNeeded()
    }
}
