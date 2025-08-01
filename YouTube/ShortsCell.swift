//
//  ShortsCell.swift
//  YouTube
//
//  Created by Алексей Авер on 01.08.2025.
//

import UIKit

final class ShortsCell: UITableViewCell {
    static let reuseId = "ShortsCell"

    private var shorts: [ShortVideo] = []
    private let collectionView: UICollectionView

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ShortsItemCell.self, forCellWithReuseIdentifier: ShortsItemCell.reuseId)
    }

    func configure(with shorts: [ShortVideo]) {
        self.shorts = shorts
        collectionView.reloadData()
    }
}

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

extension ShortsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shorts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShortsItemCell.reuseId, for: indexPath) as! ShortsItemCell
        cell.configure(with: shorts[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 240)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("🎥 Выбран шортс: \(shorts[indexPath.item].title)")
    }
}
