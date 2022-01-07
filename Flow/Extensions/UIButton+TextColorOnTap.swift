//
//  UIButton+TextColorOnTap.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/7.
//

import UIKit

extension UIButton {
    func makeTitleColorTransformerOnTap() -> UIConfigurationTextAttributesTransformer {
        return UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            if self.state != .normal {
                outgoing.foregroundColor = .accentText?.withAlphaComponent(0.3)
            }
            return outgoing
        }
    }
}
