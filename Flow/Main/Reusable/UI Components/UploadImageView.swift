//
//  UploadImageView.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/17.
//

import UIKit

class UploadImageView: UIImageView {
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
            placeholder.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            placeholder.heightAnchor.constraint(equalTo: placeholder.widthAnchor),
        ])
        return placeholder
    }()

    init() {
        super.init(frame: .zero)
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        reset()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reset() {
        image = nil
        placeholderImageView.isHidden = false
    }
}
