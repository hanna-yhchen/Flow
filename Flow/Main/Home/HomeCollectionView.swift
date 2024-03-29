//
//  HomeCollectionView.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/14.
//

import UIKit

enum HomeSection: Int, CaseIterable {
    case storybook
    case post
}

class HomeCollectionView: UICollectionView {
    convenience init(withFrame frame: CGRect) {
        self.init(frame: frame, collectionViewLayout: UICollectionViewLayout())
        self.collectionViewLayout = makeLayout()
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.backgroundColor = .systemBackground
    }

    private func makeLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10

        let layout = UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ in
            guard let section = HomeSection(rawValue: sectionIndex) else {
                fatalError("Unexpected Home Section Index")
            }

            var layoutSection: NSCollectionLayoutSection

            switch section {
            case .storybook:
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)
                    )
                )

                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .estimated(75),
                        heightDimension: .estimated(90)
                    ),
                    subitems: [item]
                )

                layoutSection = NSCollectionLayoutSection(group: group)
                layoutSection.interGroupSpacing = 8
                layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 8, trailing: 0)
                layoutSection.orthogonalScrollingBehavior = .continuous
            case .post:
                let layoutSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(1)
                )

                let item = NSCollectionLayoutItem(layoutSize: layoutSize)
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: layoutSize,
                    subitem: item,
                    count: 1
                )

                layoutSection = NSCollectionLayoutSection(group: group)
                layoutSection.interGroupSpacing = 20
            }

            return layoutSection
        }, configuration: config)
        return layout
    }
}
