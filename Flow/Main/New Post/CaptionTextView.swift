//
//  CaptionTextView.swift
//  Flow
//
//  Created by Hanna Chen on 2022/2/21.
//

import UIKit

class CaptionTextView: UITextView {
    let placeholderLabel = UILabel()

    init(placeholder: String) {
        super.init(frame: .zero, textContainer: nil)
        self.placeholderLabel.text = placeholder
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        font = .systemFont(ofSize: 16)

        addSubview(placeholderLabel)
        placeholderLabel.font = .systemFont(ofSize: 16)
        placeholderLabel.textColor = .systemGray2
        placeholderLabel.sizeToFit()
        placeholderLabel.frame.origin = CGPoint(x: textContainerInset.left + 4, y: textContainerInset.top)
    }
}
