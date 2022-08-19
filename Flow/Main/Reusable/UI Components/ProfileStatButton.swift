//
//  ProfileStatButton.swift
//  Flow
//
//  Created by Hanna Chen on 2022/2/11.
//

import UIKit

class ProfileStatButton: UIButton {
    var count = 0 {
        didSet {
            setNeedsUpdateConfiguration()
        }
    }

    init(statName: String) {
        super.init(frame: .zero)

        var config = UIButton.Configuration.plain()

        var attributedString = AttributedString(statName)
        attributedString.font = .systemFont(ofSize: 16)
        config.attributedSubtitle = attributedString
        config.titleAlignment = .center
        config.titlePadding = 5

        let attributesTransformer = UIConfigurationTextAttributesTransformer {[weak self] incoming in
            var outgoing = incoming
            if self?.state == .normal {
                outgoing.foregroundColor = .label
            } else {
                outgoing.foregroundColor = .label.withAlphaComponent(0.3)
            }
            return outgoing
        }
        config.titleTextAttributesTransformer = attributesTransformer
        config.subtitleTextAttributesTransformer = attributesTransformer

        configuration = config

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        configurationUpdateHandler = {[unowned self] button in
            var config = button.configuration

            var attributedString = AttributedString(String(self.count))
            attributedString.font = .boldSystemFont(ofSize: 24)
            config?.attributedTitle = attributedString

            button.configuration = config
        }
    }
}
