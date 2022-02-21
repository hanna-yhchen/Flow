//
//  PostCollectionView.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/20.
//

import UIKit

class PostCollectionView: UICollectionView {
    static let headerKind = "header"

    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        self.collectionViewLayout = makeLayout()
        self.backgroundColor = .systemBackground
        self.allowsSelection = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func makeLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            let layoutSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(200)
            )
            let item = NSCollectionLayoutItem(layoutSize: layoutSize)
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: layoutSize,
                subitem: item,
                count: 1
            )
            let section = NSCollectionLayoutSection(group: group)

            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(500)
                ),
                elementKind: PostCollectionView.headerKind,
                alignment: .top)
            section.boundarySupplementaryItems = [header]

            return section
        }
    }
}
