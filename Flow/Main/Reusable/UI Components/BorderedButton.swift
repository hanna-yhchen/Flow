//
//  BorderedButton.swift
//  Flow
//
//  Created by Hanna Chen on 2022/2/11.
//

import UIKit

class BorderedButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        var config = UIButton.Configuration.filled()
        var attributedString = AttributedString(title)
        attributedString.font = .boldSystemFont(ofSize: 18)
        attributedString.foregroundColor = .label
        config.attributedTitle = attributedString
        self.configuration = config
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConfiguration() {
        guard var config = configuration else { return }

        var background = config.background
        background.cornerRadius = 5
        background.strokeWidth = 1
        background.strokeColor = .systemGray4

        background.backgroundColorTransformer = UIConfigurationColorTransformer {[unowned self] _ in
            return self.state == .normal ? .systemBackground : .systemGray6
        }

        config.background = background
        configuration = config
    }
}
