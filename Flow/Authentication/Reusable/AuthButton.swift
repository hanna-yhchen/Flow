//
//  AuthButton.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/7.
//

import UIKit

class AuthButton: UIButton {
    var isLoading = false
    var isInputValid = false
    let title: String

    init(title: String) {
        self.title = title
        super.init(frame: .zero)

        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule

        config.activityIndicatorColorTransformer = UIConfigurationColorTransformer { _ in
            return .white
        }
        self.configuration = config

        /// Button's appearance changes according to `isLoading` and `isInputValid`.
        configurationUpdateHandler = {[unowned self] button in
            var config = button.configuration

            func disableButton() {
                button.isEnabled = false
                config?.attributedTitle?.foregroundColor = .disabledText
                config?.background.backgroundColor = .disabledBackground
            }

            if self.isLoading {
                config?.showsActivityIndicator = true
                config?.title = ""
                disableButton()
            } else {
                config?.showsActivityIndicator = false
                var attributedString = AttributedString(title)
                attributedString.font = .boldSystemFont(ofSize: 18)
                attributedString.foregroundColor = .white
                config?.attributedTitle = attributedString

                if self.isInputValid {
                    config?.background.backgroundColor = .tintColor
                    button.isEnabled = true
                } else {
                    disableButton()
                }
            }

            button.configuration = config
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
