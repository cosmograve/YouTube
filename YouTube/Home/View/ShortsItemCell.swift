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
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with short: ShortVideo) {
            self.short = short
            imageView.image = UIImage(named: short.imageName)
            titleLabel.text = short.title
            viewsLabel.text = short.views
        }

        // MARK: - Private
        private func setupUI() {
            contentView.layer.cornerRadius = 8
            contentView.clipsToBounds = true

            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])

            [titleLabel, viewsLabel, moreButton].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                imageView.addSubview($0)
            }

            titleLabel.font = .systemFont(ofSize: 13, weight: .semibold)
            titleLabel.textColor = .white
            titleLabel.numberOfLines = 2

            viewsLabel.font = .systemFont(ofSize: 11)
            viewsLabel.textColor = .lightGray

            let ellipsis = UIImage(systemName: "ellipsis")?
                .withConfiguration(UIImage.SymbolConfiguration(pointSize: 14,
                                                               weight: .bold))
            moreButton.setImage(ellipsis, for: .normal)
            moreButton.tintColor = .white
            moreButton.transform = CGAffineTransform(rotationAngle: .pi / 2)
            moreButton.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)

            NSLayoutConstraint.activate([
                moreButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8),
                moreButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),

                titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 8),
                titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
                titleLabel.bottomAnchor.constraint(equalTo: viewsLabel.topAnchor, constant: -4),

                viewsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                viewsLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
                viewsLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -8)
            ])
        }

        @objc private func moreTapped() {
            print("⋯ More tapped for \(short?.title ?? "")")
        }
    }
