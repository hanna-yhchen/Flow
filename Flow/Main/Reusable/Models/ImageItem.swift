//
//  ImageItem.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/12.
//

import Foundation
import UIKit

class ImageItem: Hashable {
    let image: UIImage?
    let identifier = UUID()

    init(image: UIImage?) {
        self.image = image
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    static func == (lhs: ImageItem, rhs: ImageItem) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
