//
//  HomeCollectionView.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/14.
//

import UIKit

enum HomeSection: Int {
    case story
    case feed
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
            case .story:
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)
                    )
                )

                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .absolute(80),
                        heightDimension: .absolute(80)
                    ),
                    subitems: [item]
                )
                group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(5), top: nil, trailing: .fixed(5), bottom: nil)

                layoutSection = NSCollectionLayoutSection(group: group)
                layoutSection.orthogonalScrollingBehavior = .continuous
            case .feed:
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)
                    )
                )
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)

                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .estimated(350)
                    ),
                    subitems: [item]
                )

                layoutSection = NSCollectionLayoutSection(group: group)
            }

            return layoutSection
        }, configuration: config)
        return layout
    }
}
