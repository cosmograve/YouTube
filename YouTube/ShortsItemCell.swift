//
//  ShortsItemCell.swift
//  YouTube
//
//  Created by Алексей Авер on 02.08.2025.
//

import UIKit

final class ShortsItemCell: UICollectionViewCell {
    static let reuseId = "ShortsItemCell"

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let viewsLabel = UILabel()
    private let moreButton = UIButton(type: .system)

    private var short: ShortVideo?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        titleLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        viewsLabel.font = .systemFont(ofSize: 11)
        viewsLabel.textColor = .gray
        viewsLabel.translatesAutoresizingMaskIntoConstraints = false

        moreButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        moreButton.tintColor = .darkGray
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)

        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(viewsLabel)
        contentView.addSubview(moreButton)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 16.0/9.0),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: moreButton.leadingAnchor, constant: -4),

            viewsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            viewsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            viewsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            moreButton.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            moreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }

    func configure(with short: ShortVideo) {
        self.short = short
        imageView.image = UIImage(named: short.imageName)
        titleLabel.text = short.title
        viewsLabel.text = short.views
    }

    @objc private func moreTapped() {
        print("⋯ More tapped for: \(short?.title ?? "")")
    }
}
