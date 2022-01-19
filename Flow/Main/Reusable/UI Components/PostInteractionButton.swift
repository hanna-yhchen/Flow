//
//  PostInteractionButton.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/17.
//

import UIKit

class PostInteractionButton: UIButton {
    /// A Boolean value that represents whether the user has liked or bookmarked the post and determines whether the button icon should be filled.
    var isAdopted = false {
        didSet {
            setNeedsUpdateConfiguration()
        }
    }

    var count = 0 {
        didSet {
            setNeedsUpdateConfiguration()
        }
    }

    init(iconName: String, filledIconName: String? = nil, pointSize: CGFloat) {
        super.init(frame: .zero)

        var config = UIButton.Configuration.plain()
        config.imagePadding = 10
        self.configuration = config
        self.configurationUpdateHandler = {[unowned self] button in
            var config = button.configuration

            var attributedTitle = AttributedString(String(count))
            attributedTitle.font = .systemFont(ofSize: pointSize)
            config?.attributedTitle = attributedTitle

            if self.isAdopted {
                guard let filledIconName = filledIconName else { return }
                let filledIcon = UIImage(
                    systemName: filledIconName,
                    withConfiguration: UIImage.SymbolConfiguration(pointSize: pointSize, weight: .medium)
                )
                config?.image = filledIcon
            } else {
                let hollowIcon = UIImage(
                    systemName: iconName,
                    withConfiguration: UIImage.SymbolConfiguration(pointSize: pointSize, weight: .medium)
                )
                config?.image = hollowIcon
            }

            button.configuration = config
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
