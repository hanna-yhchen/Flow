//
//  PasswordTextField.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/6.
//

import UIKit

class PasswordTextField: AuthTextField {
    init(placeholder: String) {
        super.init(placeholder: placeholder, leftIconName: "lock")

        self.isSecureTextEntry = true
        self.textContentType = .password
        self.returnKeyType = .go

        configureToggleVisibilityButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureToggleVisibilityButton() {
        guard let invisibleIcon = UIImage(
            systemName: "eye.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 10)
        ), let visibleIcon = UIImage(
            systemName: "eye.slash.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 10)
        ) else { return }

        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        config.image = invisibleIcon

        let toggleVisibilityButton = UIButton(configuration: config)
        toggleVisibilityButton.setImage(invisibleIcon, for: .normal)
        toggleVisibilityButton.addAction(
            UIAction {[weak self] _ in
                if let self = self {
                    self.isSecureTextEntry.toggle()
                    toggleVisibilityButton.setNeedsUpdateConfiguration()
                }
            },
            for: .touchUpInside
        )
        toggleVisibilityButton.configurationUpdateHandler = {[unowned self] button in
            var config = button.configuration
            if self.isSecureTextEntry {
                config?.image = invisibleIcon
                _ = becomeFirstResponder()
            } else {
                config?.image = visibleIcon
            }
            button.configuration = config
        }

        self.rightView = toggleVisibilityButton
        self.rightViewMode = .always
    }

    /// Re-insert the existing text under secure text mode to avoid the text get cleared when user enters new character
    override func becomeFirstResponder() -> Bool {
        let success = super.becomeFirstResponder()
        if isSecureTextEntry, let existingText = text {
            self.text?.removeAll()
            // Prevent revealing the last character
            insertText("\(existingText)+")
            deleteBackward()
        }
        return success
    }
}
