//
//  AuthNavigationButton.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/7.
//

import UIKit

class AuthNavigationButton: UIButton {
    convenience init(questionText: String, destinationText: String) {
        self.init()

        var aString = AttributedString("\(questionText)  \(destinationText)")
        aString.font = .systemFont(ofSize: 14)
        aString.foregroundColor = .systemGray

        if let range = aString.range(of: destinationText) {
            aString[range].font = .boldSystemFont(ofSize: 14)
            aString[range].foregroundColor = .accentText
        }

        setupConfiguration(withAttributedTitle: aString)
    }

    convenience init(destinationText: String) {
        self.init()

        var aString = AttributedString(destinationText)
        aString.font = .systemFont(ofSize: 14)
        aString.foregroundColor = .accentText

        setupConfiguration(withAttributedTitle: aString)
    }

    private func setupConfiguration(withAttributedTitle title: AttributedString) {
        var config = UIButton.Configuration.plain()

        config.attributedTitle = title
        config.titleTextAttributesTransformer = makeTitleColorTransformerOnTap()
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        self.configuration = config
    }
}
