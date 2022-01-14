//
//  ImageCell.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/11.
//

import UIKit

class ImageCell: UICollectionViewCell {
    let imageView = UIImageView()
    static let reuseIdentifier = "image-cell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
        ])
    }
}
