//
//  SectionHeader.swift
//  YouTube
//
//  Created by Алексей Авер on 08.08.2025.
//

import UIKit

final class SectionHeader: UICollectionReusableView {
    static let kind = "section-header"
    static let reuseId = "SectionHeader"

    private let image = UIImageView(image: UIImage(named: "shortsLogo"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        addSubview(image)
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            image.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    required init?(coder: NSCoder) { fatalError() }
}
