//
//  AuthTextField.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/4.
//

import UIKit

class AuthTextField: UITextField {
    let bottomLine = UIView()
    var bottomLineHeightConstraint = NSLayoutConstraint()

    init(placeholder: String, leftIconName: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder

        let leftIcon = UIImage(
            systemName: leftIconName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        )

        configureLeftView(with: leftIcon)
        configureBottomLine()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureBottomLine() {
        bottomLine.backgroundColor = .lightGray
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomLine)
        bottomLineHeightConstraint = bottomLine.heightAnchor.constraint(equalToConstant: 1)
        NSLayoutConstraint.activate([
            bottomLineHeightConstraint,
            bottomLine.leftAnchor.constraint(equalTo: leftAnchor),
            bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomLine.rightAnchor.constraint(equalTo: rightAnchor),
        ])
    }

    private func configureLeftView(with iconImage: UIImage?) {
        guard let iconImage = iconImage else { return }

        let width: CGFloat = 20
        let height: CGFloat = 20
        let padding: CGFloat = 8

        let iconView = UIImageView(frame: CGRect(x: padding, y: 0, width: width, height: height))
        iconView.image = iconImage
        iconView.contentMode = .scaleAspectFit

        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: width + (padding * 2), height: height))
        outerView.addSubview(iconView)

        leftView = outerView
        leftViewMode = .always
    }
}
