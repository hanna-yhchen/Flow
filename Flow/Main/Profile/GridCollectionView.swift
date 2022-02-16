//
//  GridCollectionView.swift
//  Flow
//
//  Created by Hanna Chen on 2022/2/14.
//

import UIKit

class GridCollectionView: UICollectionView {
    convenience init(withFrame frame: CGRect) {
        self.init(frame: frame, collectionViewLayout: UICollectionViewLayout())
        self.collectionViewLayout = makeLayout()
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.backgroundColor = .systemBackground
    }

    private func makeLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1 / 3),
                heightDimension: .fractionalWidth(1 / 3)
            )
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(1 / 3)
            ),
            subitem: item,
            count: 3
        )
        group.interItemSpacing = .fixed(1)

        let layoutSection = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: layoutSection)
        return layout
    }
}
