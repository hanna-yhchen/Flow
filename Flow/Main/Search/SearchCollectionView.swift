//
//  SearchCollectionView.swift
//  Flow
//
//  Created by Hanna Chen on 2022/2/8.
//

import UIKit

class SearchCollectionView: UICollectionView {
    convenience init(withFrame frame: CGRect) {
        self.init(frame: frame, collectionViewLayout: UICollectionViewLayout())
        self.collectionViewLayout = makeLayout()
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.backgroundColor = .systemBackground
    }

    private func makeLayout() -> UICollectionViewLayout {
        let fullWidth = frame.width
        let smallItemLength = (fullWidth - 2) / 3
        let largeItemLength = fullWidth - smallItemLength - 1

        let smallItemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(smallItemLength),
            heightDimension: .absolute(smallItemLength)
        )
        let largeItemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(largeItemLength),
            heightDimension: .absolute(largeItemLength)
        )
        let verticalPairSize = NSCollectionLayoutSize(
            widthDimension: .absolute(smallItemLength),
            heightDimension: .absolute(largeItemLength)
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(fullWidth),
            heightDimension: .absolute(largeItemLength)
        )

        let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)
        let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)
        let verticalPair = NSCollectionLayoutGroup.vertical(
            layoutSize: verticalPairSize,
            subitem: smallItem,
            count: 2
        )
        verticalPair.interItemSpacing = .fixed(1)

        let trailingLargeWithPairGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [verticalPair, largeItem]
        )
        trailingLargeWithPairGroup.interItemSpacing = .fixed(1)

        let triplePairGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: verticalPair,
            count: 3
        )
        triplePairGroup.interItemSpacing = .fixed(1)

        let leadingLargeWithPairGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [largeItem, verticalPair]
        )
        leadingLargeWithPairGroup.interItemSpacing = .fixed(1)

        let nestedGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(4 * (largeItemLength + 1))
            ),
            subitems: [
                trailingLargeWithPairGroup,
                triplePairGroup,
                leadingLargeWithPairGroup,
                triplePairGroup,
            ]
        )
        nestedGroup.interItemSpacing = .fixed(1)

        let layoutSection = NSCollectionLayoutSection(group: nestedGroup)
        let layout = UICollectionViewCompositionalLayout(section: layoutSection)
        return layout
    }
}
