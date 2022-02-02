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
        return UICollectionViewCompositionalLayout { _, layoutEnvironment in
            let config = UICollectionLayoutListConfiguration(appearance: .plain)
            let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(350)
                ),
                elementKind: PostCollectionView.headerKind,
                alignment: .top)
            section.boundarySupplementaryItems = [header]
            return section
        }
    }
}
